# RStudio Server for GWR-CUDA

首先需要构建 RStudio-CUDA，当前的 RStudio 官方 Docker 镜像只支持 `CUDA 11.8`，有一些问题:

- 用当前 Ubuntu 环境编译会出现编译器版本匹配问题
- 对新版本 Nvidia CUDA Docker Runtime toolkit 支持有问题

生成自定义的 RStudio Server CUDA 支持镜像：

```bash
./build_rstudio.sh
```

然后需要创建自定义的 GWR 代码，基于 GWmodel 2.4.1，解决如下问题：

- 默认的 GWmodel 不支持最近几年的 Nvidia GPU 架构，需要增加

生成自定义的 RStudio 支持 GWR-CUDA 镜像：

```bash
./build_gwr.sh
```

启动支持 GWR-CUDA 的 RStudio Server:

```bash
docker compose up -d
```

在 RStudio Server Terminal 界面编译支持 CUDA 的 GWmodel 库：

```bash
/rocker_scripts/install_gwr.sh
```

在 RStudio 的 Console，加载 GWmodel：

```R
> library(GWmodel)
Loading required package: robustbase
Loading required package: sp
Loading required package: Rcpp
Welcome to GWmodel version 2.4-2.
```
