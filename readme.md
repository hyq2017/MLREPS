# 0. 环境配置
## 0.0 使用环境
程序需要在Linux环境下使用，下载压缩包后解压，进入程序目录通过`chmod +x *.sh`为脚本文件赋予可执行权限。
输入文件准备需要的环境：linux，amber
程序编译运行需要的环境：linux，python3.x, tensorflow-1.6.0, ifort, mpif90(可选)

## 0.1 编译环境
程序使用Fortran编写，编译需要用到intel编译器下的`ifort`（其他Fortran编译器理论上也可以，未测试）。

- 可以直接安装`intel_parallel_studio_xe`（[安装方法](https://software.intel.com/content/www/us/en/develop/download/parallel-studio-xe-2019-install-guide-linux.html)）
- 也可以单独安装intel编译器。
- 安装完成后在命令行输入`which ifort`可以输出intel的安装目录即可。

### 0.0.1 并行计算库（可选,非必须）
为了加快计算速度，程序提供了mpi版本，使用此版本需要intel的MPI并行库,包括`mpif90`和`mpirun`。
- 如果安装了`intel_parallel_studio_xe`，则默认已经包含 `mpif90`,`mpirun`
- 或者直接安装intel impi
- 安装完成后在命令行分别输入`which mpif90`,`which mpirun`可以输出intel的安装目录即可。

## 0.2 tensorflow
程序包`code`中`package`目录下存放着机器学习残基模型以及相应的可执行文件和依赖库。
调用模型需要`python3.x`,`tensorflow-1.6.0`.

安装：
- 首先安装`anaconda`或者`miniconda`，并加入环境变量;
- 然后安装`tensorflow`:`conda install tensorflow=1.6.0`
- 验证：运行`python`,输入`import tensorflow`回车，能够正常导入即可，warning没有影响可忽略。

## 0.3 amber
需要在Linux环境下使用amber处理预蛋白质文件。
按照官方手册安装即可。

## 0.4 权限设置及编译
运行`./configure.sh`,脚本会自动赋予相关程序和脚本可执行权限，并编译串行版程序

# 1. 程序使用

## 1.1 输入文件准备
> 以下是蛋白质结构文件准备处理过程，另在code中提供了一个处理好的蛋白质输入文件`./example/input.pqr`作为测试

- 下载或准备蛋白质pdb文件
- 添加`ACE`和`NME` terminus caps: 可以使用discovery studio，如果蛋白质两端已经存在caps，则不需要再添加
- 导出得到新的蛋白质结构文件（`xxx.pdb`）
- 使用`amber`处理pdb，得到pqr文件（具体可参考amber官方教程）：
  - `pdb4amber -i xxx.pdb -o new.pdb -y -d`:pdb4amber删掉pdb中的H和H2O生成new.pdb，
  - `tleap -s -f tleap.in`:`tleap`读入`new.pdb`,输出参数`input.prmtop`和坐标文件`input.inpcrd`. (tleap.in 是tleap的使用参数)
  - （如果有需要可以使用amber的能量最小化功能对结构进行优化，输入文件为`input.prmtop`和`input.inpcrd`）
  - `ambpdb -pqr -p input.prmtop < input.inpcrd > input.pqr`: 得到`input.pqr`文件

## 1.2 运行程序
确认环境配置好，程序编译完成后，将`input.pqr`放到主目录，执行命令`./pes.sh`,该脚本会自动执行以下任务：
- `./fragment.x`: 处理蛋白质，获得残基分块，计算MM部分能量
- `./runfrag-pes.x`: 并行调用势能面模型计算分块能量和力
- `./cal_energy_pes.x`: 统计分块计算结果，输出

### 1.2.1 运行并行版（可选，非必须）
确认环境配置好(包括并行计算库)，程序编译完成后，将`input.pqr`放到主目录，执行命令`./pesmpi.sh`,该脚本会自动执行以下任务：
- `./fragment.x`: 处理蛋白质，获得残基分块，计算MM部分能量
- `mpirun -np 10 ./runfrag-pesmpi.x`: 并行调用势能面模型计算分块能量和力
- `./cal_energy_pes.x`: 统计分块计算结果，输出

## 1.3 分析结果

任务结束后，能量输出在`energy.dat`（单位Hartree）,所有原子的力输出在`force.dat`（单位Hartree/Bohr）.
如果统计能量时有残基分块出错，会将分块名输出到`fort.233`中。

### 1.3.1 benchmark
使用软件提供的输入文件`input.pqr`测试，total energy = -6182.474258 Hartree.

```
cp ./example/input.pqr .
./pes.sh
```
