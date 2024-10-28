# RStudio Server for GWR-CUDA

为什么有这个项目：

- 需要使用 RStudio Server 运行 GWmodel
- GWmodel 默认基于 CPU 运算较慢，它有 CUDA 支持库，需要手动编译
- 需要 RStudio Server 支持 CUDA，[官方的镜像](https://github.com/rocker-org/rocker-versioned2) 目前（2024-10-28）支持到 `CUDA 11.8`
- 目前手头环境都是 `CUDA 12.2`，在手动编译 `GWR-CUDA` 遇到版本适配等问题
- 因此:
    - 定制 RStudio Server，使之支持 `CUDA 12.2`
    - 修改 GWR-CUDA 编译参数，使之支持最新的 Nvidia GPU 架构（包括 Ada、Hopper 和 Blackwell）

## 构建 RStudio Server CUDA 镜像


构建 RStudio Server CUDA 镜像是基础，当前的 RStudio 官方 Docker 镜像只支持 `CUDA 11.8`，有一些问题:

- 用当前 Ubuntu 环境编译会出现编译器版本匹配问题
- 对新版本 Nvidia CUDA Docker Runtime toolkit 支持有问题

生成自定义的 RStudio Server CUDA 支持镜像：

```bash
./build_rstudio.sh
```

## 构建 GWR-CUDA 镜像

需要调整的 GWR 源代码，基于 GWmodel 2.4.1，解决如下问题：

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

## 使用 RStudio Server 多用户镜像

RStudio Server 默认只创建了 `rstudio` 用户，每个用户只能有一个会话，因此不能支持多人使用。

这里给出多用户使用的配置示例。

`multiusers.Dockerfile`:

```dockerfile
FROM rstudio-server-gwr

RUN useradd --create-home --shell /bin/bash testuser && echo 'testuser:password' | chpasswd
RUN usermod -aG staff testuser
```

`multiusers.docker-compose.yaml`:

```yaml
networks:
  rstudio-server-multiusers:

services:
  rstudio-server-multiusers:
    build:
      context: .
      dockerfile: ./multiusers.Dockerfile
    container_name: rstudio-server-multiusers
    restart: on-failure
    init: true
    volumes:
      - /dev:/dev
      - ./home/rstudio:/home/rstudio/work
      - ./home/testuser:/home/testuser/work
    networks:
      - rstudio-server-multiusers
    environment:
      - PASSWORD=rstudio1
      - ROOT=true
    ports:
      - 48787:8787
    command: ["sh", "-c", "chown -R testuser:testuser /home/testuser && /init"]
      
    privileged: true
    tty: true
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              capabilities: [gpu]
              count: all
```


