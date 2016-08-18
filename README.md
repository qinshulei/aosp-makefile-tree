# Android 编译依赖

android-6.0.1_r63 的依赖树

## 使用
通过这个编译的依赖树，帮助我们加深对 android aosp makefile 的理解。理解各个库之间的相互关系.

## 通过 make2graph 生成
+ android-m-targets-all.gexf
gexf文件，可以使用 gephi 打开，本身是xml文件，也可以直接用文本编辑器打开
+ path_module.txt
android路径和模块的对应关系
+ get_children.bash
简单脚本,查询一个targets所依赖的targets
+ get_parent.bash
简单脚本，查询一个target 上一级的 targets
+ depth_filter.bash
根据树的深度进行过滤，原始的树太深，很难流畅的打开，可以生成局部的树来浏览
