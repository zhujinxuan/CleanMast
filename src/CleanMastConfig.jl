# 文件：./src/CleanMastConfig.jl

module CleanMastConfig

using YAML

# 定义 SensorConfig, MastConfig 和 ProjectConfig 类型
struct SensorConfig
    column_format::String
    timestamp_column::String
    timestamp_format::String
end

struct MastConfig
    data_path::String
    skip_to::Int
    sensor::SensorConfig
end

struct ProjectConfig
    mast::MastConfig
end

# 解析配置文件的函数
function parse_config(dir::String)::ProjectConfig
    config_path = joinpath(dir, "config.yaml")
    if !isfile(config_path)
        error("配置文件不存在: $config_path")
    end

    # 读取并解析 YAML 配置文件
    config = YAML.load_file(config_path)

    # 使用 DataTypes.jl 验证 MastConfig 和 SensorConfig 部分
    try
        sensor_config = SensorConfig(
             config["Mast"]["sensor"]["column_format"],
             config["Mast"]["sensor"]["timestamp_column"],
             config["Mast"]["sensor"]["timestamp_format"]
        )

        mast_config = MastConfig(
             config["Mast"]["data_path"],
             config["Mast"]["skip_to"],
             sensor_config
        )
        return ProjectConfig( mast_config)
    catch e
        error("配置文件解析或验证失败: $(e.message)")
    end

end
export parse_config, MastConfig, SensorConfig, ProjectConfig

end # module CleanMastConfig

