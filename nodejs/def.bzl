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

NODEJS_BUILD_FILE_CONTENTS = """\
package(
    default_visibility = ["//visibility:public"])

filegroup(
    name = 'nodejs_tool',
    srcs = ["bin/node"],
)
"""


def nodejs_repositories():
    native.new_http_archive(
        name = 'nodejs_linux_amd64',
        url = 'https://nodejs.org/dist/v4.4.4/node-v4.4.4-linux-x64.tar.xz',
        build_file_content = NODEJS_BUILD_FILE_CONTENTS,
        sha256 = 'c8b4e3c6e07e51593dddbf1d2ec3cf0e' +
	         'c09d5c6b8c5258b37b3816cc6b7e9fe3',
	strip_prefix = "node-v4.4.4-linux-x64",
    )
