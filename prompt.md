### 项目概述
我们要做的是编写一个用于处理 CleanMast 数据的 Julia 项目。目标是完成以下两步：
1. **解析列信息**：从 CSV 文件中灵活解析列名，识别不同的数据类型。
2. **数据清洗**：根据指定的规则检测并修正错误的数据，确保数据的质量。

### 命令行输入
我们将创建一个命令行工具，接受一个目录路径作为输入，并检查该路径下是否存在 `config.yaml` 文件。

1. **实现步骤**：
   - 在 `src/CleanMast.jl` 中编写一个函数 `main()`，用于处理命令行输入。
   - 该函数将接受一个路径作为输入，并验证是否存在 `config.yaml`。

2. **代码示例**：
   下面是 `src/CleanMast.jl` 中的示例代码：
   ```julia
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
   ```

3. **运行命令**：
   在终端中运行以下命令来检查目录是否包含 `config.yaml`。
   ```sh
   julia --project=. src/CleanMast.jl <path_to_directory>
   ```

### 数据输入与输出
1. **输入**：
   - **CSV 文件**：文件包含 CleanMast 数据，其中每一列代表一种不同的数据类型。列名会提供有关数据的线索，例如风速、方向、温度等。
   - **检测规则**：一组规则用于识别时间戳错误的数据点。这些规则可能包括检测时间戳是否连续、是否有逻辑错误等。

2. **输出**：
   - **清洗后的 CSV 文件**：输出将是修正过的 CSV 文件，其中的错误时间戳已经修复，且数据质量得到了保证。
   - **日志文件**：用于记录数据清洗过程中的发现和修正的信息，例如哪些时间戳有问题，以及如何修正的。

### 示例配置文件
在 `example_project/` 目录下包含一个示例的 `config.yaml` 文件，其中包含关于 mast 数据的配置信息。以下是注释后的 `config.yaml` 示例：
```yaml
Mast:
  data_path: data.csv  # 相对路径（相对于 config.yaml），指向数据文件的位置。
  skip_to: 0  # 指定从 CSV 中跳过的行数，通常用于跳过文件头部的无效行。
  sensor:
    column_format: "*_SensorType_SensorDirection_SensorHeight_*"  # 拼写修正后的字段格式，用于解析列名。
    timestamp_column: DateTime  # 指定时间戳列的名称。
    timestamp_format: "yyyy-MM-dd HH:mm"  # 修正后的标准时间格式，与 Julia 的解析格式兼容。
  # cleaning_rules: 忽略清洗规则部分，稍后再进行讨论。
```

### 关键步骤
**步骤 1：解析列信息**
- 需要编写一个函数来灵活解析列名。
  - 列名可能包含信息如 "WindSpeed_10m"，表示风速在 10 米高度的数据。
  - 列名可以非常灵活，我们允许用户传递一个格式字符串，用于解析列名。
  - 每一列通常表示一个传感器，其格式可能是 `[a-zA-Z1-9]*`，包含传感器类型、传感器方向、传感器高度等，通过下划线 `_` 连接，且这些部分可能以不同顺序出现。
  - 我们需要通过正则表达式或者模式匹配的方法来灵活解析这些列名，确保能够识别并分类整理不同类型的数据。

**步骤 2：数据清洗**
- 编写一个数据清洗模块来检查并修复时间戳的问题。
  - 根据给定的规则，例如：
    - 检测时间戳是否是连续的，是否有缺失或者重复。
    - 检测时间间隔是否符合预期（例如每 10 分钟一个数据点）。
  - 发现问题时，采取适当的修复措施，可能包括插值、删除无效数据点或者填充缺失值。

### 接下来的讨论
1. **列名的解析**：我们可以先讨论一下如何传递格式字符串，以及这个格式字符串的语法应该是什么样的。你可以提供一些实际的示例列名，以及你希望的格式字符串形式，这样我可以帮助设计解析逻辑。
2. **数据清洗规则**：我们需要详细讨论一下你手头的规则，以确保程序能够准确检测并修复错误的数据点。

你觉得这样的流程如何？是否有需要补充或者调整的地方？另外，如果你有具体的列名或规则示例，方便分享给我，这样我们可以继续深入讨论。


