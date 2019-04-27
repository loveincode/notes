http://wangvsa.github.io/refactoring-cheat-sheet/
### 第1章 重构，### 第一个案例1
1.1 起点1
1.2 重构的### 第一步7
1.3 分解并重组statement()8
1.4 运用多态取代与价格相关的条件逻辑34
1.5 结语52
### 第2章 重构原则53
2.1 何谓重构53
2.2 为何重构55
2.3 何时重构57
2.4 怎么对经理说60
2.5 重构的难题62
2.6 重构与设计66
2.7 重构与性能69
2.8 重构起源何处71
### 第3章 代码的坏味道75
3.1 DuplicatedCode（重复代码）76
3.2 LongMethod（过长函数）76
3.3 LargeClass（过大的类）78
3.4 LongParameterList（过长参数列）78
3.5 DivergentChange（发散式变化）79
3.6 ShotgunSurgery（霰弹式修改）80
3.7 FeatureEnvy（依恋情结）80
3.8 DataClumps（数据泥团）81
3.9 PrimitiveObsession（基本类型偏执）81
3.10 SwitchStatements（switch惊悚现身）82
3.11 ParallelInheritanceHierarchies（平行继承体系）83
3.12 LazyClass（冗赘类）83
3.13 SpeculativeGenerality（夸夸其谈未来性）83
3.14 TemporaryField（令人迷惑的暂时字段）84
3.15 MessageChains（过度耦合的消息链）84
3.16 MiddleMan（中间人）85
3.17 InappropriateIntimacy（狎昵关系）85
3.18 AlternativeClasseswithDifferentInterfaces（异曲同工的类）85
3.19 IncompleteLibraryClass（不完美的库类）86
3.20 DataClass（纯稚的数据类）86
3.21 RefusedBequest（被拒绝的遗赠）87
3.22 Comments（过多的注释）87
### 第4章 构筑测试体系89
4.1 自测试代码的价值89
4.2 JUnit测试框架91
4.3 添加更多测试97
### 第5章 重构列表103
5.1 重构的记录格式103
5.2 寻找引用点105
5.3 这些重构手法有多成熟106
### 第6章 重新组织函数109
6.1 ExtractMethod（提炼函数）110
6.2 InlineMethod（内联函数）117
6.3 InlineTemp（内联临时变量）119
6.4 ReplaceTempwithQuery（以查询取代临时变量）120
6.5 IntroduceExplainingVariable（引入解释性变量）124
6.6 SplitTemporaryVariable（分解临时变量）128
6.7 RemoveAssignmentstoParameters（移除对参数的赋值）131
6.8 ReplaceMethodwithMethodObject（以函数对象取代函数）135
6.9 SubstituteAlgorithm（替换算法）139
### 第7章 在对象之间搬移特性141
7.1 MoveMethod（搬移函数）142
7.2 MoveField（搬移字段）146
7.3 ExtractClass（提炼类）149
7.4 InlineClass（将类内联化）154
7.5 HideDelegate（隐藏“委托关系”）157
7.6 RemoveMiddleMan（移除中间人）160
7.7 IntroduceForeignMethod（引入外加函数）162
7.8 IntroduceLocalExtension（引入本地扩展）164
### 第8章 重新组织数据169
8.1 SelfEncapsulateField（自封装字段）171
8.2 ReplaceDataValuewithObject（以对象取代数据值）175
8.3 ChangeValuetoReference（将值对象改为引用对象）179
8.4 ChangeReferencetoValue（将引用对象改为值对象）183
8.5 ReplaceArraywithObject（以对象取代数组）186
8.6 DuplicateObservedData（复制“被监视数据”）189
8.7 ChangeUnidirectionalAssociationtoBidirectional（将单向关联改为双向关联）197
8.8 ChangeBidirectionalAssociationtoUnidirectional（将双向关联改为单向关联）200
8.9 ReplaceMagicNumberwithSymbolicConstant（以字面常量取代魔法数）204
8.10 EncapsulateField（封装字段）206
8.11 EncapsulateCollection（封装集合）208
8.12 ReplaceRecordwithDataClass（以数据类取代记录）217
8.13 ReplaceTypeCodewithClass（以类取代类型码）218
8.14 ReplaceTypeCodewithSubclasses（以子类取代类型码）223
8.15 ReplaceTypeCodewithState/Strategy（以State/Strategy取代类型码）227
8.16 ReplaceSubclasswithFields（以字段取代子类）232
### 第9章 简化条件表达式237
9.1 DecomposeConditional（分解条件表达式）238
9.2 ConsolidateConditionalExpression（合并条件表达式）240
9.3 ConsolidateDuplicateConditionalFragments（合并重复的条件片段）243
9.4 RemoveControlFlag（移除控制标记）245
9.5 ReplaceNestedConditionalwithGuardClauses（以卫语句取代嵌套条件表达式）250
9.6 ReplaceConditionalwithPolymorphism（以多态取代条件表达式）255
9.7 IntroduceNullObject（引入Null对象）260
9.8 IntroduceAssertion（引入断言）267
### 第10章 简化函数调用271
10.1 RenameMethod（函数改名）273
10.2 AddParameter（添加参数）275
10.3 RemoveParameter（移除参数）277
10.4 SeparateQueryfromModifier（将查询函数和修改函数分离）279
10.5 ParameterizeMethod（令函数携带参数）283
10.6 ReplaceParameterwithExplicitMethods（以明确函数取代参数）285
10.7 PreserveWholeObject（保持对象完整）288
10.8 ReplaceParameterwithMethods（以函数取代参数）292
10.9 IntroduceParameterObject（引入参数对象）295
10.10 RemoveSettingMethod（移除设值函数）300
10.11 HideMethod（隐藏函数）303
10.12 ReplaceConstructorwithFactoryMethod（以工厂函数取代构造函数）304
10.13 EncapsulateDowncast（封装向下转型）308
10.14 ReplaceErrorCodewithException（以异常取代错误码）310
10.15 ReplaceExceptionwithTest（以测试取代异常）315
### 第11章 处理概括关系319
11.1 PullUpField（字段上移）320
11.2 PullUpMethod（函数上移）322
11.3 PullUpConstructorBody（构造函数本体上移）325
11.4 PushDownMethod（函数下移）328
11.5 PushDownField（字段下移）329
11.6 ExtractSubclass（提炼子类）330
……
### 第12章 大型重构359
### 第13章 重构，复用与现实379
### 第14章 重构工具401
### 第15章 总结409
参考书目413
要点列表417
索引419
