# 文件：./src/CleanMast.jl

# 运行方式：
# 使用以下命令来运行该文件，并检查配置：
# julia ./src/CleanMast.jl check:config --dir=<配置文件目录路径>

using ArgParse
include("./CleanMastConfig.jl")
using .CleanMastConfig

# 主函数：解析命令行参数并调用相应的功能
function main()
    args = Base.ARGS
    command, dir = parse_arguments(args)

    # 根据命令调用相应的函数
    if command == "check:config"
        check_config(dir)
    else
        error("无效的命令: \$command")
    end
end

# 解析命令行参数
function parse_arguments(args::Vector{String})
    s = ArgParseSettings()
    @add_arg_table! s begin
        "command"
        help = "要执行的命令，如 check:config"
        arg_type = String
        required = true

        "--dir"
        help = "指定配置文件所在的目录"
        arg_type = String
        required = true
    end
    parsed_args = parse_args(args, s)
    command = parsed_args["command"]
    return command, get(parsed_args, "dir", "")
end

# 检查配置文件是否存在并尝试解析
function check_config(dir::String)
    config_path = joinpath(dir, "config.yaml")
    if isdir(dir) && isfile(config_path)
        println("目录和配置文件存在: \$config_path")
        # 尝试解析配置文件
        try
            CleanMastConfig.parse_config(dir)
            println("配置文件解析成功")
        catch e
            error("配置文件解析失败: \$(e.message)")
        end
    else
        error("指定的目录无效或配置文件不存在: \$config_path")
    end
end

# 执行主函数
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

