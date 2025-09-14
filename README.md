

# 多端局域网文本共享

Flutter实现的多端局域网文本共享，通过部署一个python脚本服务端，以及对客户端的目标服务端ip及端口进行简单配置后即可食用

<!-- PROJECT SHIELDS -->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]


<!-- PROJECT LOGO -->
<br />

<p align="center">
  <a href="https://github.com/AHPxLIS/LanClipboard">
    <img src="assets/icons/app_icon.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">局域网剪贴板</h3>
  <p align="center">
    练习项目
  </p>
</p>

### 指南

服务端建议运行在NAS上，通过 server/runOnWindows.bat 也可在win端运行
 
###### server 目录说明

1. clipboard_config.json 内可配置端口号，历史记录条数以及密码
2. 服务端运行并接受post请求后，会将文本存储到目录下的txt文件内，以便关闭服务端后下次启动恢复记录

###### **服务端部署**

1. 确保服务端内已安装python
2. 于clipboard_config.json中填写密码和未被占用的端口号
3. ```pip install -r requirements.txt```
4. ```python clipboard_server.py```
5.  ps: win端点击runOnWindows.bat即可


### To Do?
1. 自动读取写入不同端设备的剪贴板
2. 传输粘贴的图片
3. 编译Linux端并打包release


### 作者

ahpxlis@gmail.com
ahpxlis@126.com


### 版权说明

该项目签署了MIT 授权许可，详情请参阅 [LICENSE.txt](https://github.com/AHPxLIS/LanClipboard/blob/master/LICENSE.txt)


<!-- links -->
[your-project-path]:AHPxLIS/LanClipboard
[contributors-shield]: https://img.shields.io/github/contributors/AHPxLIS/LanClipboard.svg?style=flat-square
[contributors-url]: https://github.com/AHPxLIS/LanClipboard/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/AHPxLIS/LanClipboard.svg?style=flat-square
[forks-url]: https://github.com/AHPxLIS/LanClipboard/network/members
[stars-shield]: https://img.shields.io/github/stars/AHPxLIS/LanClipboard.svg?style=flat-square
[stars-url]: https://github.com/AHPxLIS/LanClipboard/stargazers
[issues-shield]: https://img.shields.io/github/issues/AHPxLIS/LanClipboard.svg?style=flat-square
[issues-url]: https://img.shields.io/github/issues/AHPxLIS/LanClipboard.svg
[license-shield]: https://img.shields.io/github/license/AHPxLIS/LanClipboard.svg?style=flat-square
[license-url]: https://github.com/AHPxLIS/LanClipboard/blob/master/LICENSE.txt
