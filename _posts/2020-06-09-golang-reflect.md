---
layout: mypost
title:       "Golang中的反射使用参考"
subtitle:    "Go"
description: "Golang-反射"
date:        2020-06-09
author:      "Tomtao626"
image:       ""
tags:        ["反射", "Tips"]
categories:  ["GOLANG"]
---

# 1-通过反射获取反射值对象的类型和种类

```go
package main

import (
    "fmt"
    "reflect"
)

type Enum int
const(
    Zero Enum = 0
)

type Student struct{
    Name string
    Age int16
}

// 1-Name()类型名 Kind()种类
func main() {
    var stu Student
    // 获取struct实例对象
    typeOfStu := reflect.TypeOf(stu)
    fmt.Println(typeOfStu.Name(), typeOfStu.Kind())
    // 获取zero常量类型的实例对象
    typeOfZero := reflect.TypeOf(Zero)
    fmt.Println(typeOfZero.Name(), typeOfZero.Kind())
}
```

# 2-通过反射获取指针指向的元素类型

```go
package main

import (
    "fmt"
    "reflect"
)

type Student struct{
    Name string
    Age int16
}

// 2-reflect.Elem() 通过反射获取指针指向的元素类型 取元素阶段 等于对指针类型变量做了一个*操作  取地址运算符& 间接寻址运算符*
func main() {
    // 定义一个Student类型的指针变量 *Student
    var stu = &Student{
    Name: "tomtao626",
    Age: 56,
    }
    //获取结构体实例的反射类型对象
    typeOfStu := reflect.TypeOf(stu)
    //打印其类型名Name和种类Kind
    fmt.Printf("before--------name:%v, kind:%v\n", typeOfStu.Name(), typeOfStu.Kind()) //name:, kind:ptr
    //go语言的反射中，对所有的指针变量都是ptr，但注意指针类型的变量名是空，不是*Student
    //取类型的元素
    typeOfStu = typeOfStu.Elem()
    //打印其类型名Name和种类Kind
    fmt.Printf("end--------name:%v, kind:%v", typeOfStu.Name(), typeOfStu.Kind()) //name:Student, kind:struct

}
```

# 3-通过反射获取结构体的成员类型

+ 任意值通过 reflect.TypeOf() 获得反射对象信息后，如果它的类型是结构体，可以通过反射值对象（reflect.Type）的 NumField() 和 Field() 方法获得结构体成员的详细信息。
+ 与成员获取相关的 reflect.Type 的方法如下表所示。
+ 结构体成员访问的方法列表

|方法 |	说明|
| :-----: | :-------:|
|Field(i int) StructField	        |根据索引，返回索引对应的结构体字段的信息。当值不是结构体或索引超界时发生宕机|
|NumField() int	                |返回结构体成员字段数量。当类型不是结构体或索引超界时发生宕机|
|FieldByName(name string) (StructField, bool)	|根据给定字符串返回字符串对应的结构体字段的信息。没有找到时 bool 返回 false，当类型不是结构体或索引超界时发生宕机|
|FieldByIndex(index []int) StructField	        |多层成员访问时，根据 []int 提供的每个结构体的字段索引，返回字段的信息。没有找到时返回零值。当类型不是结构体或索引超界时 发生宕机|
|FieldByNameFunc( match func(string) bool) (StructField,bool)	|根据匹配函数匹配需要的字段。当值不是结构体或索引超界时发生宕机|

> 结构体字段类型
+ Type 的 Field() 方法返回 StructField 结构，这个结构描述结构体的成员信息，通过这个信息可以获取成员与结构体的关系，如偏移、索引、是否为匿名字段、结构体标签（Struct Tag）等，而且还可以通过 StructField 的 Type 字段进一步获取结构体成员的类型信息。
+ StructField 的结构如下：

```go
type StructField struct {
    Name string          // 字段名
    PkgPath string       // 字段路径
    Type      Type       // 字段反射类型对象
    Tag       StructTag  // 字段的结构体标签
    Offset    uintptr    // 字段在结构体中的相对偏移
    Index     []int      // Type.FieldByIndex中的返回的索引值
    Anonymous bool       // 是否为匿名字段
}
```

> 字段说明如下。

|字段名|说明|
| :-----: | :-------:|
|Name|为字段名称|
|PkgPath|字段在结构体中的路径|
|Type|字段本身的反射类型对象，类型为 reflect.Type，可以进一步获取字段的类型信息|
|Tag|结构体标签，为结构体字段标签的额外信息，可以单独提取|
|Index|FieldByIndex 中的索引顺序|
|Anonymous|表示该字段是否为匿名字段|

```go
package main

import (
    "fmt"
    "reflect"
)

func main() {
    type cat struct {
        Name string
        Type int `json:"type" id:"100"`
    }//声明了带有两个成员的 cat 结构体。
    //Type 是 cat 的一个成员，这个成员类型后面带有一个以```开始和结尾的字符串。这个字符串在 Go语言中被称为 Tag（标签）。一般用于给字段添加自定义信息，方便其他模块根据信息进行不同功能的处理。
    //创建cat实例
    ins := cat{Name: "tomtao626", Type: 1}// 创建 cat 实例，并对两个字段赋值。结构体标签属于类型信息，无须且不能赋值。
    //获取结构体类型的反射实例对象
    typeOfCat := reflect.TypeOf(ins)
    //遍历结构体所有成员
    for i:=0;i<typeOfCat.NumField();i++{
        //获取每个成员的结构体字段类型
        fliedtype := typeOfCat.Field(i)
        //输出name和tag
        fmt.Printf("name:%v, tag:%v\n", fliedtype.Name, fliedtype.Tag)
        //Name, ""
        //Type, tag:json:"type" id:"100"
    }
    //通过字段名找到字段类型信息
    if catType, ok := typeOfCat.FieldByName("Type"); ok{
        //从tag中取出所需的tag
        fmt.Println(catType.Tag.Get("json"),catType.Tag.Get("id")) // type 100
    }
}
```

# 4-通过反射获取值

> 可以通过下面几种方法从反射值对象 reflect.Value 中获取原值，如下表所示。

+ 反射值获取原始值的方法

|方法名	                    |说明|
| :-----: | :-------:|
|Interface() interface{}	    |将值以 interface{} 类型返回，可以通过类型断言转换为指定类型|
|Int() int64	                |将值以 int 类型返回，所有有符号整型均可以此方式返回|
|Uint() uint64	            |将值以 uint 类型返回，所有无符号整型均可以此方式返回|
|Float() float64	            |将值以双精度（float64）类型返回，所有浮点数（float32、float64）均可以此方式返回|
|Bool() bool	                |将值以 bool 类型返回|
|Bytes() []bytes	            |将值以字节数组 []bytes 类型返回|
|String() string	            |将值以字符串类型返回|

```go
package main

import (
    "fmt"
    "reflect"
)
func main() {
    var a int = 1024
    //获取反射的实例化对象
    valueOfA := reflect.ValueOf(a)
    //通过反射对象的 interface{}类型取出 通过类型断言转换
    var GetA int = valueOfA.Interface().(int)
    //通过int做强制类型转换 int64类型取出 转为原来的int类型
    var GetB int = int(valueOfA.Int())
    fmt.Println(GetA, GetB) // 1024 1024
}
```

# 5-通过反射获取结构体成员的值

```go
package main

import (
    "fmt"
    "reflect"
)
func main() {
    type Student struct {
        Name string
        Age int32
        float32
        bool
        next *Student
    }
    valueOfStu := reflect.ValueOf(Student{next: &Student{},})
    fmt.Println(valueOfStu.NumField())
    floatField := valueOfStu.Field(2)
    fmt.Println(floatField.Type())
    AgeType := valueOfStu.FieldByName("Age").Type()
    fmt.Println(AgeType)
    nextValueType := valueOfStu.FieldByIndex([]int{4,0}).Type()
    fmt.Println(nextValueType)
}
```

# 6-判断反射值的空和有效性

|方法名	                    |说明|
| :-----: | :-------:|
|IsNil() bool    |返回值是否为nil，如果值类型不是channel/slice/func/interface/map/pointer时，就会发生panic|
|IsVaild() bool  |判断值是否有效 当值本身非法时，返回false 比如当reflect.Value不包含任何值，值为nil等|

```go
package main

import (
    "fmt"
    "reflect"
)
func main() {
    var a *int
    //*int的空指针
    fmt.Println("var a*int", reflect.ValueOf(a).IsNil()) // true
    //nil值
    fmt.Println("nil", reflect.ValueOf(nil).IsValid()) // false
    //*int类型的空指针
    //(*int)(nil)的含义是将nil转换为nil，即int类型的空指针，取指针指向元素，但由于nil不指向任何元素，int类型的nil元素也不指向任何元素，值不是有效的
    fmt.Println("(*int)(nil)", reflect.ValueOf((*int)(nil)).Elem().IsValid()) // false
    //空结构体
    s := struct {}{}
    //查找s结构体中一个空字符串的成员
    fmt.Println("struct{}{}不存在的结构体成员", reflect.ValueOf(s).FieldByName("").IsValid()) // false
    //查找s结构体中一个空字符串的方法
    fmt.Println("不存在的方法", reflect.ValueOf(s).MethodByName("").IsValid()) // false
    //map
    m := map[int]int{} // 等价于 make(map[int]int)
    //MapIndex() 方法能根据给定的 reflect.Value 类型的值查找 map，并且返回查找到的结果。
    //IsNil() 常被用于判断指针是否为空；IsValid() 常被用于判定返回值是否有效。
    fmt.Println("不存在的建", reflect.ValueOf(m).MapIndex(reflect.ValueOf(3)).IsValid()) // false
}
```

# 7-通过反射修改变量的值

> 判断值可被修改条件
+ 7.1-可被寻址

```go
package main

import (
    "fmt"
    "reflect"
)
func main() {
    var a int = 1024
    //rValue := reflect.ValueOf(a)
    //rValue.SetInt(1) // panic: reflect: reflect.Value.SetInt using unaddressable value
    //无法修改 reflect.ValueOf(a) 因为a无法被寻址 SetInt正在使用一个不能被寻址的值。从 reflect.ValueOf 传入的是 a 的值，而不是 a 的地址，这个 reflect.Value 当然是不能被寻址的 修改一下
    //获取变量a的反射值对象
    rValue := reflect.ValueOf(&a)
    //取出a地址的元素
    rValue = rValue.Elem() // 使用 reflect.Value 类型的 Elem() 方法获取 a 地址的元素，也就是 a 的值。reflect.Value 的 Elem() 方法返回的值类型也是 reflect.Value。
    rValue.SetInt(1)
    fmt.Println(a) // 1
    // 注意 当reflect.Value不可寻址时，使用Addr()方法也是无法取到值的地址 虽然Addr()方法等同于语言层的&操作，Elem()等同于语言层的*操作，但并不代表其和语言层等效
}
```

+ 7.2-可被导出 Go的struct里，小写字段是非导出的，即不可从包外部访问

```go
package main

import (
    "fmt"
    "reflect"
)
func main() {
    //type Student struct {
    //	lognum int
    //}
    type Student struct {
    Lognum int
    }
    stu := Student{}
    stuValue := reflect.ValueOf(&stu) //记住是传地址
    stuValue = stuValue.Elem()
    stuTest := stuValue.FieldByName("Lognum")
    stuTest.SetInt(4)
    fmt.Println(stuTest.Int()) //panic: reflect: reflect.Value.SetInt using value obtained using unexported field
    //由于结构体成员中，如果字段没有被导出(首字母小写)，即便不使用反射也可以被访问，但不能通过反射修改 改成大写即可
}
```

> 值的修改从表面意义上叫可寻址，换一种说法就是值必须“可被设置”。那么，想修改变量值，一般的步骤是：
+ 1.取这个变量的地址或者这个变量所在的结构体已经是指针类型。
+ 2.使用 reflect.ValueOf 进行值包装。
+ 3.通过 Value.Elem() 获得指针值指向的元素值对象（Value），因为值对象（Value）内部对象为指针时，使用 set 设置时会报出宕机错误。
+ 4.使用 Value.SetXXX 设置值。


# 8-通过类型信息创建实例

> 当已知reflect.Type时，可动态的创建这个类型的实例，类型为指针 例如reflect.Type类型为int时，创建int的指针 即*int

```go
package main

import (
    "fmt"
    "reflect"
)
func main() {
    var a int
    typeOfA := reflect.TypeOf(a)
    //根据反射类型对象创建类型实例
    //使用 reflect.New() 函数传入变量 a 的反射类型对象，创建这个类型的实例值，值以 reflect.Value 类型返回。这步操作等效于：new(int)，因此返回的是 *int 类型的实例。
    newA := reflect.New(typeOfA)
    fmt.Println(newA.Type(), newA.Kind()) // *int ptr
}
```

+ 如果反射值对象（reflect.Value）中值的类型为函数时，可以通过 reflect.Value 调用该函数。
+ 使用反射调用函数时，需要将参数使用反射值对象的切片 []reflect.Value 构造后传入 Call() 方法中，调用完成时，函数的返回值通过 []reflect.Value 返回。

```go
package main

import (
    "fmt"
    "reflect"
)
func add(a, b int) int {
    return a+b
}
func main() {
    //将函数转换为反射值对象
    funcValue := reflect.ValueOf(add)
    // 构造切片
    paramList := []reflect.Value{reflect.ValueOf(10), reflect.ValueOf(20)} //将 10 和 20 两个整型值使用 reflect.ValueOf 包装为 reflect.Value，再将反射值对象的切片 []reflect.Value 作为函数的参数。
    //反射调用函数
    result := funcValue.Call(paramList) // 使用 funcValue 函数值对象的 Call() 方法，传入参数列表 paramList 调用 add() 函数。
    fmt.Println(result[0].Int())// 30  调用成功后，通过 retList[0] 取返回值的第一个参数，使用 Int 取返回值的整数值。
}
```

+ 反射调用函数的过程需要构造大量的 reflect.Value 和中间变量，对函数参数值进行逐一检查，还需要将调用参数复制到调用函数的参数内存中。
+ 调用完毕后，还需要将返回值转换为 reflect.Value，用户还需要从中取出调用值。因此，反射调用函数的性能问题尤为突出，不建议大量使用反射函数调用。


# 9-通过反射调用方法

> 和调用函数基本一致 只不过结构体需要先通过rValue.Method()先获取方法再调用

```go
package main

import (
    "fmt"
    "reflect"
)
type MyMath struct {
    PI float64
}

func (mymath MyMath) sum(a, b int) int {
    return a+b
}

func (mymath MyMath) Dec(a, b int) int {
    return a-b
}

func main() {
    //实例化struct
    myMath := MyMath{
    PI: 3.14,
    }
    rValue := reflect.ValueOf(myMath)
    //获取结构体有多少个方法
    numOfMyMath := rValue.NumMethod()
    fmt.Println(numOfMyMath)
    //构造函数参数 传入两个整型值
    paramList := []reflect.Value{reflect.ValueOf(10), reflect.ValueOf(20)}
    //调用
    result := rValue.Method(0).Call(paramList) //为什么调用的是Dec()方法
    //注意 在反射值对象方法中 方法索引的顺序不是定义的先后顺序，而是根据方法的ASCII码的顺序来从小打到排序，所以Dec()方法排在第一个 也就是Methods(0)
    fmt.Println(result[0].Int())
}
```