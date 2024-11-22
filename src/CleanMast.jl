module CleanMast

using YAML
using Logging
using Printf

"""
Main function to run the CleanMast tool.
Arguments:
  - path::String: The directory path containing config.yaml.
"""
function main()
    # 获取命令行参数
    if length(ARGS) == 0
        println("Usage: julia --project=. src/CleanMast.jl <path_to_directory>")
        return
    end
    
    # 读取路径
    path = ARGS[1]
    config_path = joinpath(path, "config.yaml")

    # 检查 config.yaml 是否存在
    if isfile(config_path)
        println("config.yaml found at: ", config_path)
    else
        println("Error: config.yaml not found in the specified directory.")
    end
end

end # module CleanMast
