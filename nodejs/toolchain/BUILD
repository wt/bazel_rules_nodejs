package(
    default_visibility = ["//src:__subpackages__"],
)

config_setting(
    name = "darwin",
    values = {"host_cpu": "darwin"},
)

config_setting(
    name = "k8",
    values = {"host_cpu": "k8"},
)

alias(
    name = "nodejs_tool",
    actual = select({
        ":k8": "@nodejs_linux_amd64//:nodejs_tool",
        ":darwin": "@nodejs_darwin_amd64//:nodejs_tool",
    }),
    visibility = ["//visibility:public"],
)
