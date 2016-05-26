_js_filetype = FileType([".js"])

SCRIPT_TEMPLATE = """\
#!/bin/bash
"{node_bin}" "{script_path}"
"""

def nodejs_binary_impl(ctx):
    ctx.file_action(
        ctx.outputs.executable,
        SCRIPT_TEMPLATE.format(node_bin=ctx.file._nodejs_tool.short_path,
                               script_path=ctx.file.main_script.short_path),
        executable=True)
    all_runfiles = [ctx.file._nodejs_tool]
    all_runfiles.append(ctx.file.main_script)
    return struct(
        runfiles=ctx.runfiles(files=all_runfiles),
    )


nodejs_binary = rule(
    nodejs_binary_impl,
    executable=True,
    attrs={
        "main_script": attr.label(
            single_file=True,
            allow_files=_js_filetype,
    ),
        "_nodejs_tool": attr.label(
            default=Label("//nodejs/toolchain:nodejs_tool"),
            single_file=True,
            allow_files=True,
            executable=True,
            cfg=HOST_CFG,
        )
    },
)


def nodejs_npm_registry_impl(repository_ctx):
    registry_data = struct(url=repository_ctx.attr.url)
    filename = 'npm_registry_data.json'
    repository_ctx.file('BUILD', 'exports_files(["' + filename + '"])')
    repository_ctx.file(filename, registry_data.to_json())

nodejs_npm_registry = repository_rule(
    nodejs_npm_registry_impl,
    local=True,
    attrs={
        "url": attr.string(mandatory=True),
    },
)


NODEJS_BUILD_FILE_CONTENTS = """\
package(
    default_visibility = ["//visibility:public"])

alias(
    name = "nodejs_tool",
    actual = "//:bin/node",
)
"""


def nodejs_repositories():
    native.new_http_archive(
        name = 'nodejs_linux_amd64',
        url = 'https://nodejs.org/dist/v4.4.5/node-v4.4.5-linux-x64.tar.xz',
        build_file_content = NODEJS_BUILD_FILE_CONTENTS,
        sha256 = 'bd6505d8a350cd83907374ea98730b0b' +
                 'a99b97ec45cee418d453a0154384805a',
        strip_prefix = "node-v4.4.5-linux-x64",
    )
    native.new_http_archive(
        name = 'nodejs_darwin_amd64',
        url = 'https://nodejs.org/dist/v4.4.5/node-v4.4.5-darwin-x64.tar.gz',
        build_file_content = NODEJS_BUILD_FILE_CONTENTS,
        sha256 = '1e729f9836e7b543724ee0b2ac902b4d' +
                 'ff4a6f7d91031d20314825b61e86127f',
        strip_prefix = "node-v4.4.5-darwin-x64",
    )

    nodejs_npm_registry(
        name="nodejs_npm_default_registry",
        url="https://registry.npmjs.org/",
    )
