#import "@preview/touying:0.6.0": *
#import themes.stargazer: *
#import "@preview/numbly:0.1.0": numbly
#show: stargazer-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [Python算法库构建实践],
    subtitle: [复杂必须存在于某处],
    author: [Mathew Shen],
    date: datetime(year: 2025, month: 2, day: 27),
    // institution: [NetEase Inc.],
    logo: emoji.package,
  ),

  // // 主题: 标准绿(Standard Green)
  config-colors(
    primary: rgb("#006600"),
    primary-dark: rgb("#004400"),
  ),

  // 主题： 马尔斯绿(Mars Green)
  // config-colors(
  //   primary: rgb("#008C8C"), // 马尔斯绿
  //   primary-dark: rgb("#31a4a4"),
  // ),

  // 主题： 克莱因蓝(Klein Blue)
  // config-colors(
  //   primary: rgb("#002FA7"), // 克莱因蓝
  //   primary-dark: rgb("#1f3a7f"),
  // ),
  // 主题： 蒂芙尼蓝(Tiffany Blue)
  // config-colors(
  //   primary: rgb("#81D8D0"), // 蒂芙尼蓝
  //   primary-dark: rgb("#5a958f"),
  // ),

  // 主题： 申布伦黄(Sunbrella Yellow)
  // config-colors(
  //   primary: rgb("#F7E14D"), // 申布伦黄
  //   primary-dark: rgb("#9e8e26"),
  // ),
)


// codly
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()


// pinit
#import "@preview/pinit:0.2.0": *


#set heading(numbering: numbly("{1}.", default: "1.1"))


#title-slide()

// #outline-slide()

= What

== 算法库是什么

- 一个库(library)/包(pacakge)/SDK

- 一个*有着易用接口, 详细文档，完善测试*的库(library)/包(pacakge)/SDK


= Why


== 算法是复杂的

#codly(languages: codly-languages)
```python
def fleiss_kappa(table: np.ndarray) -> float:
    # skip many lines here...
    assert n_total != 0, "Empty table"
    assert n_total <= n_sub * n_rat, "Check total rates count"
    p_cat = table.sum(axis=0) / n_total
    table2 = table * table
    p_rat = (table2.sum(1) - n_rates) / (n_rates * (n_rates - 1.0))
    p_mean = p_rat.mean()
    p_mean_exp = (p_cat * p_cat).sum()
    kappa = (p_mean - p_mean_exp) / (1 - p_mean_exp)
    return kappa
```

== 复杂必须存在于某处

#block(
  fill: rgb("#f4d4d4"),
  inset: 8pt,
  radius: 4pt,
  [With nowhere to go, it has to roam everywhere in your system, both in your code and in people's heads. And as people shift around and leave, our understanding of it erodes.#footnote("https://ferd.ca complexity-has-to-live-somewhere.html")],
)

#pause
#tblock(title: [Complexity Has to Live Somewhere])[
  Complexity has to live somewhere; but it *does not have to live everywhere*.

  Embrace it, give it the place it deserves, design your system and organisation knowing it exists, and focus on adapting.
]

对于算法工程来说，算法复杂性要安放的 "Somewhere" 是哪里呢？


== 算法的“无状态”特征

“无状态”是指算法的输入和输出之间的关系是确定的，不依赖于外部状态
- 天然地和业务流程解耦
- 可以自成体系，独立于业务流程之外


== 核心算法的代码量并不大

#figure(
  image("./images/ml_code.png", width: 100%),
  caption: [
    Hidden Technical Debt in Machine Learning Systems#footnote("https://papers.neurips.cc/paper/2015/file/86df7dcfd896fcaf2674f757a2463eba-Paper.pdf")
  ],
)


== 算法代码隔离的好处

1. 更好的可读性：代码的逻辑更清晰
2. 更好的可维护性：更容易进行测试，更容易进行代码重构
3. 更好地复用：更方便地应用到不同的场景中(SDK, HTTP, RPC, ...)


= How

== 算法库的构建

- 算法库的形态是一个库(Library)/包(Pacakge)/SDK

- 算法实现代码，包括算法的核心代码和相关的工具函数
  - 把代码尽可能写好: 读代码的时间远大于写代码的时间

- 算法文档：用户文档(README/文档网站等)，内部文档(注释&说明文档等)
  - README必不可少
  - 此外最好还有: CHANGELOG, CONTRIBUTING, LICENSE, ...

- 测试代码：单元测试，集成测试，属性测试，性能测试等
  - 注意：测试代码也是需要维护的代码，是负债而不是资产

== 构建工具

模板库参考MPPT#footnote("https://github.com/shenxiangzhuang/mppt")

- Package and project manager: UV
- Linter and code formatter: Ruff, Isort, Black
- Type checker: MyPy
- Documentation: MkDocs(Material for MkDocs)
- Test: Pytest, Hypothesis


== 常用工作流程

1.开发流程：需要新的算法/功能或发现Bug -> *仓库提Issue说明需求背景* -> *新建PR/MR(关联Issue)* -> 编写代码 -> 编写测试代码 -> 编写文档(CHANGELOG等) -> Code Review -> 合入主干


2.发版流程: 新建Release分支 -> 更新版本号 -> 更新CHANGELOG -> 合入主干 -> *代码仓库打Tag, 发布Release* -> Build SDK -> 发布SDK

3.Debug流程: 发现Bug -> *仓库提Issue说明Bug现象, 提供复现代码* -> 复现问题 -> 定位问题代码 -> *Blame问题代码*(找出引入问题的MR/PR) -> *新建PR/MR(关联两个Issue)* -> ……(同开发流程)


== 当我们在谈论维护时

- Status of Python versions#footnote("https://devguide.python.org/versions/")
  - 必须支持的Python版本: 所有非EOF(End of Life)版本
    - 截止2025-02月，需要支持的版本: 3.9, 3.10, 3.11, 3.12, 3.13, 3.14
    - feature阶段的版本为可选支持版本: 如当前的3.14
  - 当Python版本进入EOF阶段时，在新版本移除对应的支持
    - 如目前的3.8及之前的版本

- Status of dependencies
  - 按需或定期升级依赖库的版本

- 不断进行优化和改进
  - 使代码更可读，使文档更完善，使测试更全面


== 算法库的使用

- `uv add xxx`
- `poetry add xxx`
- `pip install xxx`


#focus-slide[
  QA
]
