---
layout: mypost
title: Working Plan
categories: [Python, Golang, 面试]
---

# **1-Golang部分**
## **1.1 数据结构**
### **1.1.1 array**

- 讲解下go数组的底层实现
- 数组的初始化

```go
func main() {
	var 数组名 [数组大小]数据类型
	var intArr [3]int
	// 当定义完数组时,其实数组的各个元素有默认值 0 
	// 赋初值 
	intArr[0]=10 
	intArr[1]=20
	intArr[2]=30
	fmt.Println(intArr)
	var arr1 [3]int
	arr2 := [3]int{1, 2, 3}
	arr3 := [...]int{1, 2, 3, 4, 5}
	arr4 := [3]int{1: 10, 2: 20}
	arr5 := [...]int{1: 10, 2: 20}
	arr6 := [3][2]int{{1, 2}, {3, 4}, {5, 6}}
	arr7 := [...][2]int{{1, 2}, {3, 4}, {5, 6}}
}
```

![golang-array.png](https://cdn.nlark.com/yuque/0/2023/png/1239868/1684191081671-e3004592-4ec6-4b96-965a-27a2cb2d8a16.png#averageHue=%23f5f3f3&clientId=u7de729bf-cca4-4&from=paste&height=288&id=u554e9151&originHeight=576&originWidth=1022&originalType=binary&ratio=2&rotation=0&showTitle=false&size=44864&status=done&style=none&taskId=u49914335-3800-4fb1-9111-402290e94e6&title=&width=511)

- 基本概念 
   - (1) 数组的地址可以通过数组名来获取 &intArr
   - (2) 数组的首元素的地址,就是数组的首地址
   - (3) 数组的各个元素的地址间隔时根据数组的类型决定的,比如 int64 → 8 int32 → 4 …
   - (4) 数组是值传递, 如果每次传参都用数组，那么每次数组都要被复制一遍, 函数传参可考虑用数组的指针,高效的利用内存,从而引出切片(引用传递)
   - (5) 数组的属性类型,默认情况是值传递,因此会进行值拷贝.数组之间不会相互影响,如果想在其他函数中,去修改原来的数组,可以使用引用传递(指针方式)

```go
arr := [3]int{1,2,3}
func test01(arr [3]int) {
		arr[0] = 66
}
test01(arr)
fmt.Println(arr)

func test02(arr *[3]int) {
		(*arr)[0] = 66
}
test02(&arr)
fmt.Println(arr)
```

- 数组的遍历

```go
//遍历数组
var arr1 [3]int
for i := 0; i < len(arr1); i++ {
    fmt.Println(arr1[i])
}
for i, v := range arr1 {
    fmt.Println(i, v)
}
```

- 数组的截取

```go
//数组的截取
var arr1 [3]int
arr1[1:2]
arr1[1:]
arr1[:2]
arr1[:]
```

- 数组的比较

```go
// 数组的比较
var arr1 [3]int
arr2 := [3]int{1, 2, 3}
// 如何比较两个数组
// 1.数组类型相同
// 2.数组长度相同
// 3.数组中的值相同
if arr1 == arr2 {
    fmt.Println("arr1==arr2")
} else {
    fmt.Println("arr1!=arr2")
}
```

- 数组的排序

```go
// 如何对数组进行排序
// 1.冒泡排序
func BubbleSort(arr *[5]int) {
	//fmt.Println("排序前arr=", (*arr))
	temp := 0
	for i := 0; i < len(*arr)-1; i++ {
		for j := 0; j < len(*arr)-1-i; j++ {
			if (*arr)[j] > (*arr)[j+1] {
				temp = (*arr)[j]
				(*arr)[j] = (*arr)[j+1]
				(*arr)[j+1] = temp
			}
		}
	}
	//fmt.Println("排序后arr=", (*arr))
}

// 2.选择排序
func SelectSort(arr *[5]int) {
	// 完成第一轮排序
	// 假设arr[0]是最小值
	for j := 0; j < len(*arr)-1; j++ {
		min := (*arr)[j]
		minIndex := j
		// 遍历后面的1~len(arr)-1比较
		for i := j + 1; i < len(*arr); i++ {
			if min > (*arr)[i] {
				// 修改min minIndex
				min = (*arr)[i]
				minIndex = i
			}
		}
		// 交换
		if minIndex != j {
			(*arr)[j], (*arr)[minIndex] = (*arr)[minIndex], (*arr)[j]
		}
		fmt.Printf("第%d次%v\n", j+1, *arr)
	}
}

// 3.插入排序
func InsertSort(arr *[5]int) {
	// 完成第一轮排序
	// 假设arr[0]是最小值
	for j := 1; j < len(*arr); j++ {
		insertVal := (*arr)[j]
		insertIndex := j - 1
		// 从大到小
		for insertIndex >= 0 && (*arr)[insertIndex] < insertVal {
			(*arr)[insertIndex+1] = (*arr)[insertIndex]
			insertIndex--
		}
		// 插入
		if insertIndex+1 != j {
			(*arr)[insertIndex+1] = insertVal
		}
		fmt.Printf("第%d次%v\n", j, *arr)
	}
}

// 4.快速排序
func QuickSort(left int, right int, arr *[5]int) {
	l := left
	r := right
	// pivot 中轴
	pivot := (*arr)[(left+right)/2]
	temp := 0
	// for循环的目标是将比pivot小的数放到左边
	// 比pivot大的数放到右边
	for l < r {
		// 从pivot的左边找到大于等于pivot的值
		for (*arr)[l] < pivot {
			l++
		}
		// 从pivot的右边找到小于等于pivot的值
		for (*arr)[r] > pivot {
			r--
		}
		// l >= r说明本次分解任务完成，break
		if l >= r {
			break
		}
		// 交换
		temp = (*arr)[l]
		(*arr)[l] = (*arr)[r]
		(*arr)[r] = temp
		// 优化
		if (*arr)[l] == pivot {
			r--
		}
		if (*arr)[r] == pivot {
			l++
		}
	}
	// 如果l == r，必须l++，r--，否则会出现栈溢出
	if l == r {
		l++
		r--
	}
	// 向左递归
	if left < r {
		QuickSort(left, r, arr)
	}
	// 向右递归
	if right > l {
		QuickSort(l, right, arr)
	}
}
```

- 数组的查找

```go
// 如何查找数组中的元素
// 1.顺序查找
func SeqSearch(arr *[6]int, findVal int) {
	// 遍历数组
	for i := 0; i < len(*arr); i++ {
		if (*arr)[i] == findVal {
			fmt.Printf("找到了，下标为%v\n", i)
			break
		} else if i == len(*arr)-1 {
			fmt.Println("找不到")
		}
	}
}
//顺序查找高级写法
func SeqSearchPro(arr *[6]int, findVal int) {
	// 遍历数组
	for i, v := range arr {
		if v == findVal {
			fmt.Printf("找到了，下标为%v\n", i)
			break
		} else if i == len(arr)-1 {
			fmt.Println("找不到")
		}
	}
}

// 2.二分查找
func BinaryFind(arr *[6]int, leftIndex int, rightIndex int, findVal int) {
	// 判断leftIndex是否大于rightIndex
	if leftIndex > rightIndex {
		fmt.Println("找不到")
		return
	}
	// 先找到中间的下标
	middle := (leftIndex + rightIndex) / 2
	if (*arr)[middle] > findVal {
		// 要查找的数，应该在leftIndex~middle-1
		BinaryFind(arr, leftIndex, middle-1, findVal)
	} else if (*arr)[middle] < findVal {
		// 要查找的数，应该在middle+1~rightIndex
		BinaryFind(arr, middle+1, rightIndex, findVal)
	} else {
		// 找到了
		fmt.Printf("找到了，下标为%v\n", middle)
	}
}

// 3.对数组进行遍历,根据索引[下标]进行查找
var arr1 [3]int
arr1[0]
arr1[1]
arr1[2]
```

- 数组的删除 
   - 在go中,数组是一种固定长度且类型相同的元素的容器·,数组定义时必须指定数组的长度,长度为数组类型的一部分,因此数组长度不可改变;故在传递函数参数时,需要考虑数组的长度.
   - 在golang中，切片（slice）是一种动态数组类型，同为连续内存空间，具有可变长度。因为切片的可变长度特性，我们可以使用切片来完成数组的删除操作。
   - 1-切片删除: 首先将数组转化为切片，然后指定要删除的下标，并通过append函数将删除的元素从切片中删除。最后打印输出删除后的切片。
   - 2-数组拷贝删除: 既然数组长度不可变,就可以利用go中的copy函数实现删除操作.指定了要删除的下标，然后通过append函数将要删除的元素从数组中删除。不同的是，我们直接将删除后的数组重新赋值给原数组。

```go
// 如何删除数组中的元素
// 1.1 删除指定位置的元素-切片删除
var arr1 [7]string{"a", "b", "c", "d", "e", "f", "g"}
// 指定删除位置
index := 2
// 输出删除位置之前和之后的元素
fmt.Println(arr1[:index], arr1[index+1:])
// 将删除前后的元素连接起来
arr1 = append(arr1[:index], arr1[index+1:]...)
// 输出删除后的数组
fmt.Println(arr1)
// 删除元素的过程
/*
a   b   c   d   e   f   g
-------------------------------------
      |                         |
      ↓    arr1[:index]          ↓   arr1[index+1:]
  a   b   c                 e   f   g
-------------             -------------
      |                        |
      |                        |
      ↓                        ↓  
      a     b     c    e     f   g
    ---------------------------------
  append(arr1[:index], arr1[index+1:]...)
*/

// 1.2 删除指定位置的元素-数组拷贝删除
var arr1 [7]string{"a", "b", "c", "d", "e", "f", "g"}
// 拷贝删除
deleteIndex := 2
if len(arr1) > deleteIndex {
		arr1 = append(arr1[:deleteIndex], arr1[deleteIndex+1:]...)
fmt.Println(arr)
}

// 2.删除指定值的元素
var arr1 [3]int
var index int
for i, v := range arr1 {
    if v == 2 {
        index = i
        break
    }
}
arr1 = append(arr1[:index], arr1[index+1:]...)
```

- 数组的插入

```go
// 如何插入元素
// 1.插入到指定位置
var arr1 [7]string{"a", "b", "c", "d", "e", "f", "g"}
// 指定插入位置
index := 2
// 指定插入元素
insertValue := "h"
// 输出插入位置之前和之后的元素
fmt.Println(arr1[:index], arr1[index:])
// 将插入前后的元素连接起来
arr1 = append(arr1[:index], append([]string{insertValue}, arr1[index:]...)...)
// 输出插入后的数组
fmt.Println(arr1)
// 插入元素的过程
/*
   a   b   c   d   e   f   g
   -------------------------------------
         |                         |
         ↓    arr1[:index]          ↓   arr1[index:]
     a   b   c                 d   e   f   g
   -------------             -------------
         |                        |
         |                        |
         ↓                        ↓
         a     b    h    c    d     e   f   g
       ---------------------------------
     append(arr1[:index], append([]string{insertValue}, arr1[index:]...)...)
*/
```

- 数组的合并

```go
// 如何合并两个数组
// 1.使用append函数
var arr1 [3]int
arr2 := [3]int{1, 2, 3}
arr3 := append(arr1[:], arr2[:]...)
fmt.Println(arr3)

// 2.使用copy函数
var arr1 [3]int
arr2 := [3]int{1, 2, 3}
arr3 := [6]int{}
copy(arr3[:], arr1[:])
copy(arr3[len(arr1):], arr2[:])
fmt.Println(arr3)
```

- 数组的去重

```go
// 如何对数组进行去重
// 1.使用map
var arr1 [5]int{1, 2, 3, 4, 5}
// 定义一个map
m := make(map[int]bool)
// 定义一个新的切片
arr2 := []int{}
// 遍历数组
for _, v := range arr1 {
    // 判断map中是否存在这个键
    if _, ok := m[v]; !ok {
    // 将这个键放入map中
    m[v] = true
    // 将这个键放入新的切片中
    arr2 = append(arr2, v)
    }
}
fmt.Println(arr2)

// 2.使用双层for循环
var arr1 [5]int{1, 2, 3, 4, 5}
// 定义一个新的切片
arr2 := []int{}
// 遍历数组
for i := 0; i < len(arr1); i++ {
    // 定义一个标记
    flag := true
    for j := i + 1; j < len(arr1); j++ {
    // 判断是否有重复元素
    if arr1[i] == arr1[j] {
        flag = false
        break
    }
    }
    // 将不重复的元素放入新的切片中
    if flag {
    arr2 = append(arr2, arr1[i])
    }
}
fmt.Println(arr2)
```

- 数组的反转

```go
// 如何对数组进行反转
// 1.使用双层for循环
var arr1 [5]int{1,2,3,4,5}
// 定义一个新的切片
arr2 := []int{}
// 遍历数组
for i := len(arr1) - 1; i >= 0; i-- {
    // 将元素放入新的切片中
    arr2 = append(arr2, arr1[i])
}
fmt.Println(arr2)

// 2.使用头尾指针
var arr1 [5]int{1,2,3,4,5}
// 定义一个新的切片
arr2 := []int{}
// 定义头尾指针
head := 0  // 头指针
tail := len(arr1) - 1  // 尾指针
// 遍历数组
for head <= tail {
    // 将头尾指针对应的元素交换
    arr1[head], arr1[tail] = arr1[tail], arr1[head]
    // 头指针向后移动
    head++
    // 尾指针向前移动
    tail--
}
fmt.Println(arr1)
```

- 数组的扩容

```go
// 如何对数组进行扩容
// 1.使用append函数
var arr1 [3]int
arr2 := [3]int{1, 2, 3}
arr3 := append(arr1[:], arr2[:]...)
fmt.Println(arr3)

// 2.使用copy函数
var arr1 [3]int
arr2 := [3]int{1, 2, 3}
arr3 := [6]int{}
copy(arr3[:], arr1[:])
copy(arr3[len(arr1):], arr2[:])
fmt.Println(arr3)
```

- 数组的拷贝

```go
// 如何对数组进行拷贝
// 1.使用copy函数
var arr1 [3]int
arr2 := [3]int{1, 2, 3}
arr3 := [6]int{}
copy(arr3[:], arr1[:])
copy(arr3[len(arr1):], arr2[:])
fmt.Println(arr3)

// 2.使用for循环
var arr1 [3]int
arr2 := [3]int{1, 2, 3}
// 遍历数组
for i := 0; i < len(arr1); i++ {
    // 将arr2中的元素赋值给arr1
    arr1[i] = arr2[i]
}
fmt.Println(arr1)
```

- 数组的应用案例

```go
// 创建一个byte类型的26个元素的数组,分别放置'A'-'Z'.使用for循环访问所有元素并打印出来
func main() {
		var myChars [26]byte
for i:=0;i<2;i++{
		myChars[i] = 'A'+byte(i)
		}
for i:=0;i<26;i++{
		fmt.Printf("%c ", myChars[i])
		}
}

// 求数组的最大值,并得到对应的下标
func main() {
    var intArr [5]int = [...]int{1, -1, 9, 90, 11}
    maxVal := intArr[0]
    maxValIndex := 0
    for i:=1;i<len(intArr);i++{
        if maxVal<intArr[i]{
            maxVal = intArr[i]
            maxValIndex = i
            }
        }
}
fmt.Printf("maxVal=%v maxValIndex=%v", maxVal, maxValIndex)

// 求一个数组的和一级平均值 for-range
func main() {
    var intArr [5]int = [...]int{1, -1, 9, 90, 11}
    sum := 0
    for _, val := range intArr {
        sum += val
    }
    fmt.Println("sum=", sum, "avg=", float64(sum)/float64(len(intArr)))
}

// 随机生成五个数,并将其反转打印
func main() {
    var intArr [5]int
	// 为了每次生成的随机数不一样,需要给一个seed值
	lens := len(intArr)
	rand.Seed(time.Now().UnixNano())
	for i:=0;i<lens;i++{
        intArr[i] = rand.Intn(100)
    }
    fmt.Println("交换前=", intArr)
    temp := 0
    for i:=0;i<lens/2;i++{
        temp = intArr[lens-1-i]
        intArr[len-1-i] = intArr[i]
        intArr[i] = temp
    }
    fmt.Println("交换后=", intArr)
}
```

### **1.1.2 slice**

> 讲解下go切片的底层实现


```go
// 切片的底层实现
// 切片的底层是一个可以动态变化的数组
// 切片的数据结构
type slice struct {
    ptr *[100]int  // 指向底层数组的指针
    len int  // 切片的长度
    cap int  // 切片的容量
}
```

```go
// 定义一个长度为10的整型数组
a := [10]int{11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
fmt.Printf("origin array arr: %v\n", a)
// 对数组进行切片
s := a[3:7]
fmt.Printf("slice s: %v\n", s)
fmt.Printf("slice s:%v len(s):%v cap(s):%v\n", s, len(s), cap(s))
fmt.Printf("array:%x, s.array:%x, s[0] address:%x\n", &a[3], (*reflect.SliceHeader)(unsafe.Pointer(&s)).Data, &s[0])
s[0] = 24
fmt.Printf("after modify slice s: %v\n", s)
fmt.Printf("after modify array arr: %v\n", a)

/*
origin array arr: [11 12 13 14 15 16 17 18 19 20]
slice s: [14 15 16 17]
slice s:[14 15 16 17] len(s):4 cap(s):7
array:c0000b4018, s.array:c0000b4018, s[0] address:c0000b4018
after modify slice s: [24 15 16 17]
after modify array arr: [11 12 13 24 15 16 17 18 19 20]
*/
// 既然说切片复用的数组的存储空间，那我们把切片结构中的数组指针以及指向数组的元素a[3]地址打出来看看，并通过切片来修改元素
// 从程序打印结果可以看到，切片的数组指针array字段和数组a[3]地址是相同的，验证了s是复用了数组a的存储空间，结构体中的数组指针指向了a[3]，len=high-low，cap取决数组的长度，并且因为共享存储空间，通过修改切片的数据，反映到了数组的数据也修改了
// 为什么不用数组的指针做形参而是用切片，首先，切片作为参数传递，性能损耗是恒定的而且很小的，就是上边的runtime.slice的结构体实例，另外就是切片有比数组更强大的功能使用
```

![array-slice.png](https://cdn.nlark.com/yuque/0/2023/png/1239868/1684191218143-a34cf1e9-4abe-4ba3-96f0-ee36e013c544.png#averageHue=%23f7f7f7&clientId=u7de729bf-cca4-4&from=paste&height=338&id=u00a716b7&originHeight=676&originWidth=1254&originalType=binary&ratio=2&rotation=0&showTitle=false&size=65042&status=done&style=none&taskId=u9b99e88c-1209-4b9a-b54d-91b5304c636&title=&width=627)

- make方式和直接声明方式,底层数据布局如下

```go
// 不指定cap, 默认为len
s2 := make([]int, 5)
fmt.Printf("slice s2 len:%d, cap:%d\n", len(s2), cap(s2))
// 指定cap, len为0
s3 := make([]int, 5, 10)
fmt.Printf("slice s3 len:%d, cap:%d\n", len(s3), cap(s3))

// 空切片与nil切片
var s4 []int
fmt.Printf("slice s4 len:%d, cap:%d\n", len(s4), cap(s4))
fmt.Printf("slice s4 == nil:%v\n", s4 == nil)
s5 := []int{}
fmt.Printf("slice s5 len:%d, cap:%d\n", len(s5), cap(s5))
fmt.Printf("slice s5 == nil:%v\n", s5 == nil)
fmt.Printf("s4.array:%x s5.array:%x\n", (*reflect.SliceHeader)(unsafe.Pointer(&s4)).Data, (*reflect.SliceHeader)(unsafe.Pointer(&s5)).Data)
s6 := make([]int, 0)
fmt.Printf("slice s6 len:%d, cap:%d\n", len(s6), cap(s6))
s7 := make([]int, 0, 0)
fmt.Printf("slice s7 len:%d, cap:%d\n", len(s7), cap(s7))
s8 := make([]int, 0, 10)
fmt.Printf("slice s8 len:%d, cap:%d\n", len(s8), cap(s8))

/*
slice s2 len:5, cap:5
slice s3 len:5, cap:10
slice s4 len:0, cap:0
slice s4 == nil:true
slice s5 len:0, cap:0
slice s5 == nil:false
s4.array:0 s5.array:c000104e18
slice s6 len:0, cap:0
slice s7 len:0, cap:0
slice s8 len:0, cap:10
*/
```

![slice2.png](https://cdn.nlark.com/yuque/0/2023/png/1239868/1684191327160-00a72a20-073c-434f-9c09-c9203dad7366.png#averageHue=%23fafafa&clientId=u7de729bf-cca4-4&from=paste&height=276&id=u86d25038&originHeight=552&originWidth=1222&originalType=binary&ratio=2&rotation=0&showTitle=false&size=53605&status=done&style=none&taskId=u7d0bb80a-089c-4a94-94c1-0abc00090cf&title=&width=611)

- 切片的初始化

```go
// 切片的初始化
// 1.使用make函数
var s1 []int
s2 := make([]int, 0)
s3 := make([]int, 0, 0)
// 2.使用切片字面量
s4 := []int{}
s5 := []int{1, 2, 3}
s6 := []int{1, 2, 3, 4, 5, 6, 7, 8, 9}
```

- 切片的常用操作 
   - 通过索引访问切片元素，如`arr[1]`
   - 切片的遍历，如使用`for range`语句遍历切片
   - 切片的追加，使用`append()`函数将元素追加到切片末尾
   - 切片的拷贝，使用`copy()`函数将一个切片的元素拷贝到另一个切片中
   - 切片的切割，使用`arr[start:end]`的方式对切片进行切割，得到一个新的切片
   - 切片的长度和容量，分别使用`len()`和`cap()`函数获取切片的长度和容量
   - 切片的比较，使用`reflect.DeepEqual()`函数比较两个切片是否相同
- 切片的遍历

```go
// 切片的遍历
// 1.使用for循环
var s1 []int{1, 2, 3, 4, 5}
for i := 0; i < len(s1); i++ {
    fmt.Println(s1[i])
}
// 2.使用for range循环
var s1 []int{1, 2, 3, 4, 5}
for index, value := range s1 {
    fmt.Println(index, value)
}
```

- 切片的截取

```go
// 切片的截取
// 1.截取切片中的元素
var s1 []int{1, 2, 3, 4, 5}
s2 := s1[1:3]
fmt.Println(s2)
```

- 切片的切片 - 通过[low:high]基于已有的切片创建新的切片，比如我们基于上边的切片s定义一个s1，s1 := s[low:high]，此时的内存布局是这样的：

```go
// 数组
a := [10]int{11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
fmt.Printf("origin a:%v\n", a)
// 切片
s := a[3:7]
fmt.Printf("slice s:%v len(s):%v cap(s):%v\n", s, len(s), cap(s))
fmt.Printf("array:%x, s.array:%x, s[0] address:%x\n", &a[3], (*reflect.SliceHeader)(unsafe.Pointer(&s)).Data, &s[0])

s[0] = 24
fmt.Printf("after modify slice s:%v\n", s)
fmt.Printf("after modify array a:%v\n", a)

// 切片的切片
s1 := s[1:3]
fmt.Printf("slice s1:%v len(s1):%v cap(s1):%v\n", s1, len(s1), cap(s1))
fmt.Printf("array:%x, s1.array:%x, s1[0] address:%x\n", &a[4], (*reflect.SliceHeader)(unsafe.Pointer(&s1)).Data, &s1[0])
s1[0] = 25
fmt.Printf("after modify slice s:%v\n", s)
fmt.Printf("after modify array a:%v\n", a)
fmt.Printf("after modify array s1:%v\n", s1)

/*
origin a:[11 12 13 14 15 16 17 18 19 20]
slice s:[14 15 16 17] len(s):4 cap(s):7
array:c0000b4018, s.array:c0000b4018, s[0] address:c0000b4018
after modify slice s:[24 15 16 17]
after modify array a:[11 12 13 24 15 16 17 18 19 20]
slice s1:[15 16] len(s1):2 cap(s1):6
array:c0000b4020, s1.array:c0000b4020, s1[0] address:c0000b4020
after modify slice s:[24 25 16 17]
after modify array a:[11 12 13 24 25 16 17 18 19 20]
after modify array s1:[25 16]
*/

// 基于切片s定义新切片s1，同样输出新切片的数组指针，以及切片s的第一个元素的地址和原数组a[4]的地址，并通过s1来修改元素
// 从打印结果看，新切片s1的数组指针array字段和数组a[4]的地址以及切片s的第一个元素的地址是相同的，证明新切片和原切片都是共享底层数组存储空间的，并且通过修改s1，也反映到了切片s和数组a
```

![截屏2023-05-16 03.27.07.png](https://cdn.nlark.com/yuque/0/2023/png/1239868/1684191351332-9d8b0a58-fb74-4b80-8bc9-e32954ad1782.png#averageHue=%23f5f5f5&clientId=u7de729bf-cca4-4&from=paste&height=340&id=u1d819b9b&originHeight=680&originWidth=1266&originalType=binary&ratio=2&rotation=0&showTitle=false&size=74672&status=done&style=none&taskId=uc9fa6b74-f2ce-4e91-9cea-fce3d5b7ec8&title=&width=633)

- 切片的动态扩容

```go
// 切片的动态扩容
var s []int
fmt.Printf("len(s)=%d,cap(s)=%d\n", len(s), cap(s))
s = append(s, 11)
fmt.Printf("len(s)=%d,cap(s)=%d\n", len(s), cap(s))
s = append(s, 12)
fmt.Printf("len(s)=%d,cap(s)=%d\n", len(s), cap(s))
s = append(s, 13)
fmt.Printf("len(s)=%d,cap(s)=%d\n", len(s), cap(s))
s = append(s, 14)
fmt.Printf("len(s)=%d,cap(s)=%d\n", len(s), cap(s))
s = append(s, 15)
fmt.Printf("len(s)=%d,cap(s)=%d\n", len(s), cap(s))

/*
len(s)=0,cap(s)=0
len(s)=1,cap(s)=1
len(s)=2,cap(s)=2
len(s)=3,cap(s)=4
len(s)=4,cap(s)=4
len(s)=5,cap(s)=8
*/

// 可以看到len是随着追加线性增长的,但cap不是,见下图
```

![截屏2023-05-16 03.36.36.png](https://cdn.nlark.com/yuque/0/2023/png/1239868/1684191366883-870fb1c3-8a18-4d8d-93c6-2d6e147e2f36.png#averageHue=%23fafafa&clientId=u7de729bf-cca4-4&from=paste&height=975&id=u605409f8&originHeight=1950&originWidth=1540&originalType=binary&ratio=2&rotation=0&showTitle=false&size=326694&status=done&style=none&taskId=u8dc593e8-fbdb-47d4-8255-aae355df97f&title=&width=770)

- append会根据切片的需要,在当前数组容量无法满足的情况下,动态分配新的数组,把旧数组里面的数组复制到新数组,之后新数组作为切片的底层数组,旧数组会被GC垃圾回收掉.具体扩容策略是: 
   - (1) 所需容量大于原来容量的2倍,则最终容量为所需容量
   - (2) 不满足(1)的情况下,在原数组容量小于1024时,新数组容量是原来数组容量的2倍
   - (3) 原数组容量大于等于1024的时候，新数组的容量，每次增加原容量的25%，直到大于所需容量为止
   - 看到append的实现后，其实重新分配底层数组并且复制数据的操作代价还是挺大的，尤其是元素较多的清下，一个是重新分配的代价，另一个就是旧数组带来的频繁gc问题，那么如何减少这种代价呢，一个有效的方法就是根据切片的使用场景，预估出切片的容量，在定义切片的时候，使用make内置函数带cap参数的方式来定义，即 s := make([]int，len, cap)，这样可以减少重新分配底层数组的次数以及gc的频率，并且性能也会提高很多
- 切片的拷贝 
   - 切片赋值 (浅拷贝)
   - copy函数 (深拷贝)

```go
// 切片的拷贝
s := []int{11, 12, 13, 14, 15, 16, 17, 18, 19, 20}
s1 := s
fmt.Printf("s:%p\n", s)
fmt.Printf("slice s:%v, len:%d, cap:%d\n", s, len(s), cap(s))
fmt.Printf("s1:%p\n", s1)
fmt.Printf("slice s1:%v, len:%d, cap:%d\n", s1, len(s1), cap(s1))
fmt.Printf("s:%v, s1:%v\n", *(*reflect.SliceHeader)(unsafe.Pointer(&s)), *(*reflect.SliceHeader)(unsafe.Pointer(&s1)))

s2 := make([]int, len(s))
_ = copy(s2, s)
fmt.Printf("s2:%p\n", s2)
fmt.Printf("slice s2:%v, len:%d, cap:%d\n", s2, len(s2), cap(s2))
fmt.Printf("s:%v, s2:%v\n", *(*reflect.SliceHeader)(unsafe.Pointer(&s)), *(*reflect.SliceHeader)(unsafe.Pointer(&s2)))

/*
s:0xc0000b4000
slice s:[11 12 13 14 15 16 17 18 19 20], len:10, cap:10
s1:0xc0000b4000
slice s1:[11 12 13 14 15 16 17 18 19 20], len:10, cap:10
s:{824634458112 10 10}, s1:{824634458112 10 10}
s2:0xc0000b4050
slice s2:[11 12 13 14 15 16 17 18 19 20], len:10, cap:10
s:{824634458112 10 10}, s2:{824634458192 10 10}
*/

// 赋值的浅拷贝,新切片和原切片是共享底层数组空间的,不论对谁修改,都会反映到了另一个切片上;
// 而copy函数,新切片是创建了新的底层数组空间,修改不会对原切片造成影响
```

- 切片是非线程安全的 
   - 在并发写同一个切片时,并不是线程安全的,并不会按照切片的顺序追加

```go
// 切片是非线程安全的
// 定义一个空切片
s := make([]int, 0)
wg := sync.WaitGroup{}
// 创建100个goroutine,每个goroutine都往切片添加元素,理论长度应该是100
for i := 0; i < 100; i++ {
	wg.Add(1)
	go func(i int) {
		defer wg.Done()
		s = append(s, i)
	}(i)
}
wg.Wait()
fmt.Printf("slice:%v\nlen:%v\ncap:%v\n", s, len(s), cap(s))

/*
slice:[3 0 1 2 13 9 10 11 12 5 4 18 14 15 16 17 20 19 21 22 24 23 25 28 26 27 31 29 30 33 32 35 34 36 38 37 39 43 40 41 42 48 44 45 46 47 51 49 50 52 53 54 55 63 56 57 58 59 60 61 62 67 64 65 66 69 68 70 71 74 72 73 77 75 76 79 78 80 82 81 84 83 85 86 87 88 89 91 90 95 92 93 94 97 96 98 99]
len:97
cap:128
*/

// 实际长度是97, append在并发的情况下,是会被覆盖的,所以最终切片长度不是100
// 要保证结果符合预期,必须加锁做保护
s := make([]int, 0)
wg := sync.WaitGroup{}
lock := sync.Mutex{}
// 创建100个goroutine,每个goroutine都往切片添加元素,理论长度应该是100
for i := 0; i < 100; i++ {
	wg.Add(1)
	go func(i int) {
		defer wg.Done()
		l.lock()
		s = append(s, i)
		l.Unlock()
	}(i)
}
wg.Wait()
fmt.Printf("slice:%v\nlen:%v\ncap:%v\n", s, len(s), cap(s))

/*
slice:[2 0 1 6 3 4 5 8 7 9 10 11 12 13 14 15 16 21 17 18 19 20 23 22 24 25 26 27 28 35 29 30 31 34 39 36 37 33 38 32 41 40 42 50 43 44 45 46 47 48 49 56 54 55 51 57 52 58 53 59 60 61 62 63 64 69 65 66 67 68 72 70 71 73 74 75 76 78 77 79 80 85 81 82 83 84 89 90 86 87 88 91 94 92 93 96 95 97 98 99]
len:100
cap:128
*/
// 切片的长度是100，保证了并发协程之间不会覆盖写入，不过要保证顺序，还要做下其它逻辑
```

-  string和切片 
   -  string底层是一个byte数组,因此string也可以进行切片处理 
```go
str := "abcdefg"
fmt.Printf("%v\n", str)
slice := str[3:]
fmt.Printf("%v", slice)

/*
abcdefg
defg
*/
```
 

   -  string和切片在内存中的形式,以abcd画出内存示意图<br />![截屏2023-05-16 04.07.35.png](https://cdn.nlark.com/yuque/0/2023/png/1239868/1684191377286-243cea13-82a5-483a-baf6-a38a3443e053.png#averageHue=%23e0ecc8&clientId=u7de729bf-cca4-4&from=paste&height=197&id=u1d1eacc8&originHeight=394&originWidth=676&originalType=binary&ratio=2&rotation=0&showTitle=false&size=166609&status=done&style=none&taskId=udaf30ce8-9ef6-4d26-b45f-6c64fedc580&title=&width=338)
   -  string是不可变的,即不可以通过str[0]=’x’方式来修改字符串 
   -  如需修改字符串,可以先将string转换为[]byte / 或者 []rune 修改 重写为 string 
```go
str := "abcdefg"
fmt.Println("before str=", str)
arr1 := []byte(str)
arr1[0] = 'x'
str = string(arr1)
fmt.Println("after str=", str)

arr2 := []rune(str)
arr2[0] = '我'
str = string(arr2)
fmt.Println("after str=", str)

/*
before str= abcdefg
after str= xbcdefg
after str= 我bcdefg
*/
```
 

-  切片应用案例 
   -  实现一个斐波拉契数列 
```go
func fbn(n int) []uint64 {
    // 声明一个切片 切片大小为n
    fbnSlice := make([]uint64, n)
    fbnSlice[0] = 1
    fbnSlice[1] = 1
    // for循环来存放斐波拉契数列
    for i := 2; i < n; i++ {
        fbnSlice[i] = fbnSlice[i-1] + fbnSlice[i-2]
    }
    return fbnSlice
}

func main() {
    fbnSlice := fbn(10)
    fmt.Println(fbnSlice)
}
```
 

### **1.1.3 Map**

> 讲解下go map的底层实现


```go
type hmap struct {
    count int // 元素数量
		// map中元素的个数，使用len返回就是该值
    flags uint8 // 标志位
		// 状态标记
    // 1: 迭代器正在操作buckets
    // 2: 迭代器正在操作oldbuckets 
    // 4: go协程正在像map中写操作
    // 8: 当前的map正在增长，并且增长的大小和原来一样
    B uint8 // 位移量
		// buckets桶的个数为2^B
    noverflow uint16 // 溢出数量
		// 溢出桶的个数
    hash0 uint32 // 哈希种子
		// key计算hash时的hash种子
    buckets unsafe.Pointer // 桶指针
		// 指向的是桶的地址
    oldbuckets unsafe.Pointer // 扩容前的桶指针
		// 旧桶的地址，当map处于扩容时旧桶才不为nil
    nevacuate uintptr // 溢出桶的迁移进度
		// map扩容时会逐步讲旧桶的数据迁移到新桶中，此字段记录了旧桶中元素的迁移个数当 nevacuate>=旧桶元素个数时数据迁移完成
    extra *mapextra // 指向额外的区域
		// 扩展字段
}
// 底层实现是一个散列表, 在这个散列表中,主要出现的数据结构有两种,一个是hmap,另一个是bmap(bucket)
```
![截屏2023-05-16 04.40.00.png](https://cdn.nlark.com/yuque/0/2023/png/1239868/1684191389962-30d4c82d-ea31-46da-945c-73d2a1691e6c.png#averageHue=%23f9f9f9&clientId=u7de729bf-cca4-4&from=paste&height=543&id=u996346f7&originHeight=1086&originWidth=1874&originalType=binary&ratio=2&rotation=0&showTitle=false&size=367522&status=done&style=none&taskId=ue10e6bcd-9c55-4283-9fa9-0d006260b8b&title=&width=937)

- map 是一个散列表，底层实现使用 hmap 和 bmap 实现。

Map是Go中的一种关联数据类型，也称为哈希表或字典。Map的元素是无序的，每个元素都由一个键和一个值组成。Map中的键必须是可比较的类型，如整数、浮点数、复数、布尔型、字符串和指针等，值可以是任意类型。

Map的初始化

通过字面量

```
m := map[string]int{"apple": 1, "banana": 2, "orange": 3}
```

通过make函数

```
m := make(map[string]int)
```

Map的常用操作

- 插入键值对，使用`m[key] = value`的方式向Map中插入一个键值对
- 获取键值对，使用`m[key]`的方式获取Map中指定键的值
- 删除键值对，使用`delete(m, key)`的方式删除Map中指定键的值
- 判断键是否存在，使用`value, ok := m[key]`的方式判断Map中是否存在指定键，如果存在则返回键对应的值和true，否则返回0和false
- 遍历Map，使用`for range`语句遍历Map中的所有键值对

sync.map是线程安全的,实现了读写锁,在读取的时候不会阻塞写入,在写入的时候不会阻塞读取,但是写入的时候会阻塞写入,读取的时候会阻塞读取

```go
type Map struct {
	mu Mutex
	read atomic.Value // readOnly
	dirty map[interface{}]*entry
	misses int
}
```

### 1.1.4 Struct

Struct是Go中的一种自定义的复合类型，可以将不同类型的数据组合成一个新的类型。Struct中的各个字段可以是不同的类型，可以是内置类型、数组、切片、Map、Struct或指针等。Struct类型可以像内置类型一样进行声明、初始化、赋值和传递等操作。

> 讲解下go struct的底层实现

#### struct的初始化

通过字面量

```
type Person struct {
    Name string
    Age  int
}

p := Person{Name: "Tom", Age: 18}
```

通过new函数

```
p := new(Person)
p.Name = "Tom"
p.Age = 18
```

Struct的常用操作

- 访问Struct中的字段，使用`.`符号访问Struct中的字段，如`p.Name`
- Struct的比较，使用`reflect.DeepEqual()`函数比较两个Struct是否相同

```go
type struct {
    name string
    age int
}
```

> struct的比较只有相同类型的结构体才能比较,结构体是否相同不但与属性类型个数有关,还与属性顺序相关结构体是相同的,但是结构体属性中有不可以比较的类型,如slice,map但是可以使用reflect.DeepEqual()进行比较


```go
sn1 := struct {
    name string
    age  int
}{"张三", 18}
sn2 := struct {
    age  int
    name string
}{18, "张三"}

// sn1,sn2就是不同的结构体,不能比较
// 使用reflect.DeepEqual()进行比较
if reflect.DeepEqual(sn1, sn2) {
    fmt.Println("sn1==sn2")
} else {
    fmt.Println("sn1!=sn2")
}
```

### **1.1.5 Interface**

> Go 语言中的 interface 是一种抽象类型，用于定义对象的行为，即接口中包含一组方法定义，但不包含实现。一个类型如果实现了某个接口中定义的所有方法，就可以被认为是实现了该接口。Go 语言中的接口可以被嵌套、继承和实现多次。


在 Go 语言中，接口是一种类型，它定义了一组方法，但是没有实现。一个类型如果实现了接口中定义的所有方法，就可以被认为是实现了该接口。这种方式实现了面向对象中的“接口隔离原则”，即客户端不应该依赖它不需要使用的方法。
#### Go 语言中的接口定义：

```
type interfaceName interface {
    method1(param1 type1, param2 type2) returnType1
    method2(param1 type3, param2 type4) returnType2
    ...
}
```

其中，`interfaceName` 表示接口的名称，`method1`、`method2` 等表示接口中定义的方法，`param1`、`param2` 等表示方法的参数，`returnType1`、`returnType2` 等表示方法的返回值类型。

在使用接口时，可以将实现了该接口的类型的实例赋值给该接口类型的变量，例如：

```
type MyInt int

func (m MyInt) Double() int {
    return int(m * 2)
}

var x interface{} = MyInt(10)
fmt.Println(x.(Doubleer).Double())
```

在上述代码中，我们定义了一个名为 `MyInt` 的类型，并为其定义了一个 `Double()` 方法。由于 `MyInt` 类型实现了 `Doubleer` 接口，因此可以将 `MyInt` 类型的实例赋值给 `interface{}` 类型的变量 `x`，然后调用 `x` 的 `Double()` 方法。

需要注意的是，接口类型的变量是一种动态类型，可以在运行时根据实际类型进行调用，而不是在编译时确定。这样可以在一定程度上提高代码的灵活性和可复用性。同时，Go 语言的接口实现还支持多重继承，即一个类型可以实现多个接口。这样可以更加灵活地组合和复用代码。

总之，Go 语言中接口是一种非常重要的特性，可以帮助我们实现抽象和灵活的设计。通过接口的多态特性，我们可以将具体的实现与抽象的接口分离，从而实现更加灵活和可复用的代码。

#### interface实现继承与多态

-  接口类型是一种抽象的类型，它不会暴露出所包含的数据的格式，也不会关心这些数据的组织方式和存储方式，它只会关心方法的声明。 
-  接口类型是对其它类型行为的抽象和概括，因为只有方法的声明，没有方法的实现，所以接口类型本身不能创建实例，但是可以指向一个实现了该接口的自定义类型的变量。 
-  通过接口，可以实现多态，即一个接口类型可以定义一组方法，不管具体类型是否实现了这些方法，都可以通过接口类型的变量来调用这些方法。 
-  接口的实现就是一个自定义类型的方法集合，只要实现了该接口的所有方法，就表示实现了该接口，因此，接口类型也可以实现继承。 
-  接口类型的变量可以保存任何实现了该接口的实例，因此，接口类型也可以实现多态。 
-  接口类型的变量在调用方法时，会自动判断该变量指向的实例的类型，并调用该类型的同名方法。 
-  接口类型的变量在调用方法时，如果实例类型没有实现该方法，那么会抛出异常，因此，在调用接口类型的方法时，一定要确保接口类型的变量指向了某个实例。 
-  接口类型的变量在调用方法时，如果实例类型实现了多个接口，那么在调用方法时，会根据实例类型的不同，调用不同的方法。 
-  在golang中对多态的特点体现从语法上并不是很明显。 我们知道发生多态的几个要素： 
   -  1、有interface接口，并且有接口定义的方法。 
   -  2、有子类去重写interface的接口。 
   -  3、有父类指针指向子类的具体对象 

那么，满足上述3个条件，就可以产生多态效果，就是，父类指针可以调用子类的具体方法。

- 空接口(interface{})可以存储任意类型的数据，类似于Java中的Object类型。
- 接口类型的变量是一种动态类型，可以在运行时根据实际类型进行调用，而不是在编译时确定。
- Go语言的接口实现还支持多重继承，即一个类型可以实现多个接口。

#### interface的空接口和非空接口

- 空接口(interface{})可以存储任意类型的数据，类似于Java中的Object类型。

```go
var MyInterface interface{}

type eface struct {      //空接口
_type *_type         //类型信息
data  unsafe.Pointer //指向数据的指针(go语言中特殊的指针类型unsafe.Pointer类似于c语言中的void*)
}
```

- 空接口使用eface结构体实现，eface结构体中包含两个字段，分别是数据类型和数据值。
- 空接口可以存储任意类型的数据，但是在使用空接口存储数据时需要进行类型断言，否则会报错。

```go

- 非空接口(interface{})只能存储指定类型的数据，类似于Java中的泛型。

```go
type MyInterface interface {
		function()
}

type iface struct {
  tab  *itab
  data unsafe.Pointer
}
```

- 非空接口使用iface结构体实现，iface结构体中包含两个字段，分别是类型和数据。
- 非空接口只能存储指定类型的数据，但是在使用非空接口存储数据时不需要进行类型断言。

### **1.1.6 Channel**

空读写阻塞，写关闭异常，读关闭空零值

> - 讲解下go channel的底层实现原理


Channel 是 Go 中的一种基本类型，它提供了一种通信机制，可以用于协程之间的同步和数据传输。Channel 是一种类型安全的、引用类型的、并发安全的、阻塞的、先进先出的队列。

#### Channel 的实现原理

- Channel 是由一个结构体和一个指向该结构体的指针组成的。
- Channel 的队列是一个循环链表，每个节点包含一个元素和一个指向下一个节点的指针。
- Channel 的读写操作是通过互斥锁和条件变量实现的。
1. Channel 结构体

Channel 结构体包含两个队列，分别是发送队列和接收队列，以及一个互斥锁和两个条件变量，用于控制对队列的读写操作。

```
type hchan struct {
    qcount   uint           // 队列中元素的数量
    dataqsiz uint           // 队列的容量
    buf      unsafe.Pointer // 队列指针
    elemsize uint16         // 元素大小
    closed   uint32         // Channel 是否已经关闭的标志
    elemtype *_type         // 元素类型
    sendx    uint           // 发送队列的起始位置
    recvx    uint           // 接收队列的起始位置
    recvq    waitq          // 等待接收的 Goroutine 队列
    sendq    waitq          // 等待发送的 Goroutine 队列
    lock     mutex          // 互斥锁
}
```

1. 发送队列和接收队列

发送队列和接收队列都是由一个双向链表实现的，每个节点包含一个元素和一个指向下一个节点和上一个节点的指针，用于实现队列的先进先出特性。

```
type sudog struct {
    // ...
    next *sudog
    prev *sudog
}
```

1. 互斥锁和条件变量

互斥锁和条件变量用于实现对队列的读写操作的同步和阻塞。其中，互斥锁用于保证同一时间只有一个 Goroutine 对队列进行读写操作，条件变量用于实现对 Goroutine 的阻塞和唤醒。

```
type mutex struct {
    key uintptr
    sem sema
}

type sema struct {
    // ...
    wait waitq
}

type waitq struct {
    first *sudog
    last  *sudog
}
```

#### Channel 的发送和接收操作

1. 发送操作

当执行发送操作时，会先判断 Channel 是否已经关闭，如果已经关闭，则会直接返回；否则，会判断发送队列是否已满，如果已满，则会将当前 Goroutine 阻塞，直到有接收者接收数据或者 Channel 被关闭；如果发送队列未满，则会将数据放入发送队列，然后唤醒一个接收者 Goroutine。

```
func chansend(c *hchan, ep unsafe.Pointer, block bool, callerpc uintptr) bool {
    // ...
    if c.closed != 0 {
        unlock(&c.lock)
        panic("send on closed channel")
    }
    if c.qcount < c.dataqsiz {
        // ...
        if sg := c.sendq.dequeue(); sg != nil {
            // ...
            send(c, sg, ep, func() { unlock(&c.lock) }, callerpc)
            return true
        }
        // ...
        return true
    }
    // ...
    return false
}
```

1. 接收操作

当执行接收操作时，会先判断 Channel 是否已经关闭，如果已经关闭并且接收队列为空，则会直接返回；如果接收队列不为空，则会将接收队列中的数据取出并返回；否则，会将当前 Goroutine 阻塞，直到有发送者发送数据或者 Channel 被关闭。

```
func chanrecv(c *hchan, ep unsafe.Pointer, block bool, callerpc uintptr) (selected bool, received bool) {
    // ...
    if c.closed != 0 && c.qcount == 0 {
        unlock(&c.lock)
        return false, false
    }
    if c.qcount > 0 {
        // ...
        if sg := c.sendq.dequeue(); sg != nil {
            // ...
            recv(c, sg, ep, func() { unlock(&c.lock) }, callerpc)
            return true, true
        }
        // ...
        return true, true
    }
    // ...
    return false, false
}
```

#### Channel 的初始化

通过 make 函数

```
ch := make(chan int)
```

#### Channel 的常用操作

- 发送数据，使用 `ch <- value` 的方式向 Channel 中发送一个数据。
- 接收数据，使用 `value := <- ch` 的方式从 Channel 中接收一个数据。
- 关闭 Channel，使用 `close(ch)` 的方式关闭 Channel，关闭后的 Channel 不能再发送数据，但仍然可以接收数据。
- 判断 Channel 是否关闭，使用 `value, ok := <- ch` 的方式判断 Channel 是否关闭，如果 Channel 已经关闭，则返回 false，否则返回 true。

#### Channel 的注意事项

- 如果向一个已经关闭的 Channel 发送数据，会导致 panic。
- 如果从一个已经关闭且没有未读数据的 Channel 中接收数据，会返回该数据类型的零值。
- 如果从一个已经关闭的 Channel 中接收数据，会返回该 Channel 中剩余的所有数据。

Channel 是 Go 中非常重要的并发原语，它的底层实现基于队列、互斥锁和条件变量，通过阻塞和唤醒 Goroutine 来实现对数据的同步和传输。Channel 是 Go 中的一种基本类型，它提供了一种通信机制，可以用于协程之间的同步和数据传输。Channel 是一种类型安全的、引用类型的、并发安全的、阻塞的、先进先出的队列。

- channel是goroutine之间通信的一种方式，可以用于同步内存访问，避免竞态条件的出现
- channel的底层实现是基于同步原语实现的，每个通道都有一个单独的等待队列，用于存储等待读取通道的goroutine和等待写入通道的goroutine
- 发送和接收数据时，会先检查通道的状态，如果通道为空，则接收操作会被阻塞，直到有数据可读，如果通道已满，则发送操作会被阻塞，直到有空间可写


### **1.1.7 nil**

> nil可以用作interface、function、pointer、map、slice和channel的“空值”。但是如果不指定的话,Go语言会自动将其初始化为对应类型的零值.


在 Golang 中，`nil` 是一个预定义的标识符，用于表示指针、接口、切片、字典和通道类型的“空值”。<br />`nil` 可以用于以下类型：

- 指针
- 接口
- 切片
- 字典
- 通道
- 函数

在 Golang 中，`nil` 是一个预定义的标识符，用于表示指针、接口、切片、字典和通道类型的“空值”。

#### 指针
在 Golang 中，指针类型的零值为 `nil`。如果一个指针变量的值为 `nil`，则表示该指针变量不指向任何有效的内存地址。
```
var p *int
if p == nil {
    fmt.Println("p is nil")
}
```

#### 接口
在 Golang 中，接口类型的零值为 `nil`。如果一个接口变量的值为 `nil`，则表示该接口变量不包含任何值。
```
var a interface{}
if a == nil {
    fmt.Println("a is nil")
}
```

#### 切片
在 Golang 中，切片类型的零值为 `nil`。如果一个切片变量的值为 `nil`，则表示该切片变量不指向任何有效的切片。
```
var s []int
if s == nil {
    fmt.Println("s is nil")
}
```

#### 字典
在 Golang 中，字典类型的零值为 `nil`。如果一个字典变量的值为 `nil`，则表示该字典变量不指向任何有效的字典。
```
var m map[string]int
if m == nil {
    fmt.Println("m is nil")
}
```

#### 通道
在 Golang 中，通道类型的零值为 `nil`。如果一个通道变量的值为 `nil`，则表示该通道变量不指向任何有效的通道。
```
var c chan int
if c == nil {
    fmt.Println("c is nil")
}
```

#### 函数
在 Golang 中，函数类型的零值为 `nil`。如果一个函数变量的值为 `nil`，则表示该函数变量不指向任何有效的函数。
```
var f func(int) int
if f == nil {
    fmt.Println("f is nil")
}
```
在 Golang 中，`nil` 是一个预定义的标识符，用于表示指针、接口、切片、字典和通道类型的“空值”。如果一个变量的值为 `nil`，则表示该变量不指向任何有效的内存地址、值或对象。

## 1.2 并发和调度

在Go中，使用Goroutine实现并发，Goroutine是一种轻量级的线程，可以在单一的线程中实现并发执行。Go语言中的并发采用CSP（Communicating Sequential Processes）模型，通过Channel来进行协程之间的通信。


### 1.2.1 Goroutine

Goroutine是Go语言中的一种轻量级线程，它比操作系统的线程更轻量级，可以在单一的线程中实现并发执行。Goroutine的执行由Go语言的运行时环境（runtime）调度，可以通过关键字`go`来启动一个Goroutine。

Goroutine的启动

使用关键字`go`启动Goroutine

```
go func() {
    // Goroutine的执行体
}()
```

使用函数启动Goroutine

```
func f() {
    // Goroutine的执行体
}

go f()
```

Goroutine的常用操作

- 同步操作，使用Channel实现Goroutine之间的同步，如使用带缓冲的Channel实现Goroutine之间的数据传递和同步
- 并发安全，使用互斥锁和读写锁等机制保证共享变量的并发安全
- 垃圾回收，使用runtime包中的函数进行垃圾回收设置


### 1.2.2 GMP

GMP是Go语言运行时环境（runtime）中实现并发和调度的重要组件，它由三个部分组成：Goroutine、M（Machine）和P（Processor）。

- Goroutine是轻量级线程，运行在M上。
- M是操作系统线程的抽象，负责调度Goroutine的执行。
- P是逻辑处理器，负责将Goroutine绑定到真正的线程上执行。

GMP的实现保证了Goroutine的高效调度和执行，同时也保证了Go语言的高并发性能。


### 1.2.3 三色标记法

三色标记法是Go语言运行时环境（runtime）中实现垃圾回收的重要算法，它使用三种颜色表示对象的状态，分别是白色、灰色和黑色。

- (1)在垃圾回收过程中，首先将所有对象标记为白色，
- (2)然后从根对象开始遍历所有可达对象，将其标记为灰色，
- (3)然后遍历所有灰色对象关联的对象，将其标记为灰色或黑色，
- (4)最后将所有未被标记为黑色的对象回收。

三色标记法具有高效、可靠、准确的特点，可以保证垃圾回收的性能和正确性。


### 1.2.4 CSP

CSP是Go语言并发模型的核心思想，它是一种基于消息传递的并发模型，即通过Channel实现Goroutine之间的通信和同步。CSP模型具有简洁、安全、可靠的特点，可以有效地避免并发编程中的竞态条件和死锁等问题。CSP模型是Go语言并发编程的核心思想之一，也是Go语言高并发性能的重要保障。

### 1.2.5 defer

defer语句用于延迟执行函数调用，它的特点是不管函数是否出现异常，都会在函数退出时执行。defer语句通常用于释放资源、解除锁定、关闭文件等操作。

```go
func f() {
    defer fmt.Println("f")
    defer fmt.Println("f1")
    defer fmt.Println("f2")
    panic("error")
}

func main() {
    f()
}
```

### 1.2.6 new和make

new和make都是Go语言中用于创建对象的内置函数，它们的用法如下：

```go
new(T) // 创建类型为T的对象，并返回其地址
make(T, args) // 创建类型为T的对象，根据args参数初始化该对象，并返回其地址
```

> - new和make的区别： 
>    - 二者都是内存的分配（堆上），但是make只用于slice、map以及channel的初始化（非零值）；而new用于类型的内存分配，并且内存置为零。所以在我们编写程序的时候，就可以根据自己的需要很好的选择了。
>    - make返回的还是这三个引用类型本身；而new返回的是指向类型的指针。
> 
 



# **2-Python部分**

## **2.1 数据结构**

### 2.1.1 哈希表 Hash 

哈希表是一种基于键值对存储的数据结构，可以快速地进行插入、查找和删除操作。哈希表的实现基于哈希函数，通过将键值映射到唯一的哈希地址来实现快速访问。

Python中的字典（dict）就是一种哈希表的实现，可以使用大括号或dict()函数来创建字典。

```
# 创建字典
d = {"a": 1, "b": 2, "c": 3}
d = dict(a=1, b=2, c=3)

# 访问字典
print(d["a"])

# 插入或修改键值对
d["d"] = 4
d.update({"e": 5})

# 删除键值对
del d["a"]
d.pop("b")
```

Python中的集合（set）也是一种哈希表的实现，可以使用大括号或set()函数来创建集合。

```
# 创建集合
s = {1, 2, 3}
s = set([1, 2, 3])

# 访问集合
for x in s:
    print(x)

# 添加或删除元素
s.add(4)
s.remove(3)

# 集合运算
s1 = {1, 2, 3}
s2 = {2, 3, 4}
print(s1 | s2)  # 并集
print(s1 & s2)  # 交集
print(s1 - s2)  # 差集
```

### 2.1.2 字符串 String 

字符串是一种不可变的序列类型，可以用来存储文本数据。在Python中，字符串使用单引号、双引号或三引号来表示，单引号与双引号的区别在于单引号中可以包含双引号，双引号中可以包含单引号，而三引号则可以包含多行文本。

```
# 创建字符串
s = 'hello world'
s = "hello world"
s = """hello
world"""

# 访问字符串
print(s[0])
print(s[-1])
print(s[1:5])

# 字符串运算
print(s + '!')
print(s * 3)

# 字符串方法
print(s.upper())
print(s.replace('world', 'python'))
```

字符串的底层实现是一个由字符组成的数组，每个字符使用Unicode编码来表示。在Python 3中，字符串默认使用Unicode编码，可以使用encode()方法将字符串编码为字节序列，使用decode()方法将字节序列解码为字符串。

```
# 编码和解码
s = '你好，世界'
b = s.encode('utf-8')
s = b.decode('utf-8')
```

字符串是一种常见的数据类型，在Python中有着广泛的应用。除了常规的操作外，Python还提供了丰富的字符串方法和正则表达式模块，可以方便地进行字符串处理和匹配。


### **2.1.3** 列表 List
在Python中，list是一种经常使用的数据类型，用于存储一组有序的元素。它支持添加、删除、修改和查找等操作，并提供了丰富的方法来进行操作。

- 在Python中，**列表（List）**是一种经常使用的数据类型，用于存储一组有序的元素。它支持添加、删除、修改和查找等操作，并提供了丰富的方法来进行操作。
- List的底层实现是一个由元素组成的数组，可以通过下标来访问和修改元素。当需要添加或删除元素时，Python会重新分配一段更大或更小的内存，并将旧的元素拷贝到新的内存中。这种动态的分配和释放内存的方式，使得List可以自动调整大小，提供高效的添加和删除操作。
- 除了基本的操作外，List还提供了许多方法来进行操作，如`append()`、`insert()`、`remove()`、`pop()`、`sort()`、`reverse()`等。这些方法可以方便地操作List，提高开发效率。
- 需要注意的是，由于List的底层实现是一个数组，当需要对List进行大量的添加或删除操作时，可能会导致频繁的内存分配和拷贝，从而影响性能。这时可以考虑使用其他数据结构，如`deque`或`collections`模块中的`OrderedDict`。


### **2.1.4 集合 Set**

Python 中的 set 是一种无序且不重复的容器。在 Python 中，set 类型实际上是 dict 类型的一种特殊实现，其中所有键的值都是 None。set 也是一种可迭代的对象，因此可以使用循环语句对其进行遍历。

- set 的主要特点有： 
   - 无序性：set 中的数据没有顺序之分，因此不能使用索引和切片来访问 set 中的元素。
   - 唯一性：set 中的元素不允许重复，如果试图向 set 中添加一个已经存在的元素，则不会有任何影响。
   - 可变性：set 中的元素可以动态地添加和删除。
- set 的底层实现原理是基于哈希表的，因此在 set 中查找元素的时间复杂度是 O(1) 级别的。当向 set 中添加元素时，Python 会先计算该元素的哈希值，然后根据哈希值找到该元素应该被插入到哈希表中的哪个位置。如果该位置已经存在元素，那么就会进行链表的操作，将新元素插入到链表的末尾。如果该位置还没有元素，那么就直接将该元素插入到该位置。
- 需要注意的是，由于 set 的底层实现是基于哈希表的，因此 set 中的元素必须是可哈希的，即必须具有不可变性。因此，set 中不能包含列表、字典等可变类型的元素。如果需要使用可变类型的元素，可以使用 frozenset 类型。frozenset 类型是一种不可变的 set 类型，因此可以作为 set 中的元素。
- 另外，set 还支持一些常用的集合操作，如并集、交集、差集等。可以使用 set 对象的方法进行操作，也可以使用运算符进行操作。


### **2.1.5 Dict**

- Python中的字典数据类型是无序的，并且使用键值对存储数据。字典中的键必须是唯一的，而值则不必。字典是可变的。

#### 基本操作

- 创建字典：可以使用花括号{}或者内置函数dict()来创建字典，也可以通过键值对列表创建字典。
- 访问字典中的值：可以使用[]符号或者get()方法来访问字典中的值。如果使用[]符号访问不存在的键，会引发KeyError异常。如果使用get()方法访问不存在的键，不会引发异常，而是返回None或者指定的默认值。
- 修改字典：可以使用[]符号或者update()方法来修改字典中的键值对。如果使用[]符号修改不存在的键，会创建新的键值对。如果使用update()方法修改不存在的键，也会创建新的键值对。
- 删除键值对：可以使用del语句或者pop()方法来删除字典中的键值对。如果使用pop()方法删除不存在的键，会引发KeyError异常。如果使用pop()方法删除不存在的键，不会引发异常，而是返回None或者指定的默认值。
- 遍历字典：可以使用for循环遍历字典的键值对。可以使用keys()方法遍历字典的键，values()方法遍历字典的值，items()方法遍历字典的键值对。

#### 示例代码

```
# 创建字典
dict1 = {'name': 'Tom', 'age': 18, 'gender': 'male'}
dict2 = dict(name='Tom', age=18, gender='male')
dict3 = dict([('name', 'Tom'), ('age', 18), ('gender', 'male')])
print(dict1, dict2, dict3)

# 访问字典中的值
print(dict1['name'])
print(dict1.get('name', 'default'))

# 修改字典
dict1['name'] = 'Jerry'
dict1.update({'age': 20, 'score': 90})
print(dict1)

# 删除键值对
del dict1['score']
dict1.pop('gender')
print(dict1)

# 遍历字典
for key, value in dict1.items():
    print(key, value)
for key in dict1.keys():
    print(key)
for value in dict1.values():
    print(value)
```

Python中的字典使用哈希表来实现，通过哈希表的快速查找和插入操作，使得字典可以高效地处理大量的数据。

#### 哈希冲突
> - 在Python中，字典使用哈希表来实现。哈希表是一种根据关键码值(Key Value)而直接进行访问的数据结构，它通过把关键码值映射到表中一个位置来访问记录，以加快查找的速度。哈希表的映射函数叫作哈希函数，存放记录的数组叫作哈希表。<br />在哈希表的实现中，可能会出现哈希冲突，即不同的关键字可能会映射到同一个位置，这时需要使用哈希冲突解决方法来解决。
> - 开放地址法<br />开放地址法是指当出现哈希冲突时，就去寻找下一个空的哈希表位置，直到找到一个空的位置为止。这种方法要求哈希表中的每个位置都被探测到，以便找到一个空的位置。开放地址法有三种探测方法：线性探测、二次探测和双重哈希。其中，线性探测是最简单的一种探测方法，它的探测顺序是依次向后探测。
> - 链表法<br />链表法是指当出现哈希冲突时，将冲突的所有关键字都存储在一个链表中。这种方法的优点是可以在哈希表中存储任意数量的关键字，缺点是需要使用额外的空间来存储链表。<br />在Python中，字典使用的是链表法来解决哈希冲突。当哈希冲突时，将冲突的关键字存储在一个链表中。由于Python中的链表是通过指针来实现的，因此可以动态地添加和删除节点，从而实现高效的哈希冲突解决方法。


### **2.1.6 tuple **元组

在 Python 中，元组（tuple）是一种不可变的序列类型，它可以存储任意类型的数据，包括数字、字符串、列表、字典等。与列表不同的是，元组一旦创建就不能修改，因此可以作为字典的键或者集合的元素。

元组使用圆括号 () 来表示，多个元素之间用逗号隔开。在创建元组时，可以省略括号，Python 会自动将逗号分隔的数据转换为元组。

```
# 创建元组
t1 = (1, 2, 3)
t2 = 4, 5, 6
t3 = ()  # 空元组
t4 = (1,)  # 只有一个元素的元组需要在元素后面添加逗号

# 访问元组中的元素
print(t1[0])
print(t1[-1])
print(t1[1:])

# 元组运算
print(t1 + t2)
print(t1 * 3)

# 元组方法
print(t1.index(2))
print(t1.count(1))
```

元组的底层实现原理与列表类似，也是一个由元素组成的数组。不同的是，元组是不可变的，因此在创建元组时，Python 会为每个元素分配一段内存，并将元素的值存储在对应的内存中。当需要访问元组中的元素时，Python 会根据元素的位置计算出对应的内存地址，然后直接读取该地址中的数据。

由于元组是不可变的，因此在修改元组时，Python 不会重新分配内存，而是会引发 TypeError 异常。

```
# 修改元组
t1[0] = 4  # TypeError: 'tuple' object does not support item assignment
```

虽然元组不支持修改操作，但是可以通过拼接、切片等方式来创建新的元组。需要注意的是，这些操作都会创建新的元组对象，而不是修改原有的元组。

元组是 Python 中常用的数据类型之一，在编写程序时经常用到。与列表不同，元组不可变，因此可以避免意外修改数据的情况。同时，元组也支持列表中常用的操作，如索引、切片、拼接等，可以方便地处理数据。


## 2.2 魔法方法

### **2.2.1 协程asyncio/await**

> - Python中的协程asyncio/await 
>    - 协程是一种用户态的轻量级线程，协程的调度完全由用户控制。协程拥有自己的寄存器上下文和栈。
>    - 协程调度切换时，将寄存器上下文和栈保存到其他地方，切换回来时，恢复先前保存的寄存器上下文和栈。因此：
>    - 协程能保留上一次调用时的状态（即所有局部状态的一个特定组合），每次过程重入时，就相当于进入上一次调用的状态，换种说法：进入上一次离开时所处逻辑流的位置。
>    - 协程本质上是个单线程，在一个线程中执行，那和多线程比，协程有何优势？
>    - 最大的优势就是协程极高的执行效率。因为子程序切换不是线程切换，由程序自身控制，因此，没有线程切换的开销，和多线程比，线程数量越多，协程的性能优势就越明显。
>    - 第二大优势就是不需要多线程的锁机制，因为只有一个线程，也不存在同时写变量冲突，在协程中控制共享资源不加锁，只需要判断状态就好了，所以执行效率比多线程高很多。
>    - 因为协程是一个线程执行，那怎么利用多核CPU呢？最简单的方法是多进程+协程，既充分利用多核，又充分发挥协程的高效率，可获得极高的性能。
>    - Python对协程的支持是通过generator实现的。
>    - 在generator中，我们不但可以通过for循环来迭代，还可以不断调用next()函数获取由yield语句返回的下一个值。
>    - 但是Python的yield不但可以返回一个值，它还可以接收调用者发出的参数。
>    - 传统的生产者-消费者模型是一个线程写消息，一个线程取消息，通过锁机制控制队列和等待，但一不小心就可能死锁。
>    - 如果改用协程，生产者生产消息后，直接通过yield跳转到消费者开始执行，待消费者执行完毕后，切换回生产者继续生产，效率极高：
>    - 用Python实现生产者-消费者模型，通过协程控制生产者和消费者协作完成任务。

> - 代码示例

```python
# 协程
import asyncio

async def hello():
    print('Hello world!')
    # 异步调用asyncio.sleep(1):
    r = await asyncio.sleep(1)
    print('Hello again!')

# 获取EventLoop:
loop = asyncio.get_event_loop()
# 执行coroutine
loop.run_until_complete(hello())
loop.close()
# 输出
# Hello world!
# (暂停约1秒)
# Hello again!
```

### **2.2.2 装饰器wrap**

> - 装饰器是 Python 的一个重要部分。简单地说：他们是修改其他函数的功能的函数。他们有助于让我们的代码更简短，也更Pythonic（Python范儿）。 
>    - 装饰器的返回值也是一个函数对象。
>    - 装饰器在加载模块时立即执行。

> - 代码示例

```python
# 装饰器
def decorator(func):
    def wrapper():
        print('wrapper of decorator')
        func()
    return wrapper

@decorator
def func():
    print('func')

func()
# 输出
# wrapper of decorator
# func
```

### **2.2.3 垃圾回收**

- Python使用垃圾回收机制来自动管理内存，避免内存泄漏和指针错误等问题。Python中的垃圾回收机制是基于引用计数的，即对象被引用一次计数器加一，当计数器为0时，对象被自动回收。
- 除了引用计数外，Python还使用了分代回收机制来进一步优化垃圾回收性能。分代回收机制将对象分为三代，新创建的对象为第0代，每次经过一次垃圾回收后，对象就会升级到下一代，当第2代对象需要回收时，才会回收所有代的对象。这种分代回收机制可以更加高效地回收垃圾对象，减少垃圾回收时的开销。
- 另外，Python还提供了一些工具来帮助开发者跟踪内存使用情况，如gc模块和memory_profiler模块。这些工具可以用于监测内存泄漏、查看内存使用情况以及优化代码性能等。

### **2.2.4 单例模式**

- 单例模式是一种常用的软件设计模式，该模式的主要目的是确保某一个类只有一个实例存在。当你希望在整个系统中，某个类只能出现一个实例时，单例对象就能派上用场。
- 在Python中，单例模式的实现方法有多种，如使用装饰器、元类等。其中，使用装饰器是实现单例模式的最佳方法。
- 代码示例

```python
# 单例模式
def singleton(cls):
    instances = {}
    def wrapper(*args, **kwargs):
        if cls not in instances:
            instances[cls] = cls(*args, **kwargs)
        return instances[cls]
    return wrapper

@singleton
class Foo(object):
    pass

foo1 = Foo()
foo2 = Foo()
print(foo1 is foo2)
# 输出
# True
```

### **2.2.5 生成器**

> - 生成器 
>    - 生成器是一种特殊的迭代器，它的元素是按需生成的，而不是一次性生成所有元素。
>    - 生成器的元素只能访问一次，因为生成器并不把所有的值都存储在内存中，而是在运行时生成值。
>    - 生成器的元素只能按照顺序访问，不能跳过元素或者往回访问元素。

> - 生成器的创建
> - 生成器的创建有两种方法，一种是通过生成器表达式，另一种是通过yield关键字。
> - 生成器表达式
> - 生成器表达式是一种类似于列表推导的生成器。它的创建方法是将列表推导的中括号换成小括号。
> - 代码示例

```python
# 生成器表达式
gen = (x ** 2 for x in range(10))
print(gen)
print(next(gen))
print(next(gen))
print(next(gen))
# 输出
# <generator object <genexpr> at 0x0000020F6F9F5C80>
# 0
# 1
# 4

# yield关键字
def gen():
    for i in range(10):
        yield i ** 2

gen = gen()
print(gen)
print(next(gen))
print(next(gen))
print(next(gen))
# 输出
# <generator object gen at 0x0000020F6F9F5C80>
# 0
# 1
# 4
```

### **2.2.6 迭代器**

> - 迭代器 
>    - 迭代器是一种特殊的对象，它具有next方法，每次调用next方法时，迭代器返回它的下一个值，当迭代器没有值可返回时，抛出StopIteration异常。
>    - 迭代器可以是无限的，例如全体自然数的迭代器。
>    - 迭代器可以是惰性的，例如range函数返回的迭代器。
>    - 迭代器可以是无序的，例如字典的迭代器。
>    - 迭代器可以是不能回头的，例如文件对象的迭代器。
>    - 迭代器可以是不能复制的，例如zip函数返回的迭代器。
>    - 迭代器可以是不能重复的，例如集合的迭代器。
>    - 迭代器可以是不能重新开始的，例如filter函数返回的迭代器。
>    - 迭代器可以是不能传递的，例如map函数返回的迭代器。

> - 迭代器的创建 
>    - 迭代器的创建有两种方法，一种是通过可迭代对象的iter方法，另一种是通过yield关键字。
>    - iter方法
>    - iter方法是一种创建迭代器的简便方法，它的原理是调用可迭代对象的iter方法，返回一个迭代器。
>    - 代码示例

```python
# iter方法
lst = [1, 2, 3]
it = iter(lst)
print(it)
print(next(it))
print(next(it))
print(next(it))
# 输出
# <list_iterator object at 0x0000020F6F9F5C50>
# 1
# 2
# 3

# yield关键字
def gen():
    yield 1
    yield 2
    yield 3

it = gen()
print(it)
print(next(it))
    
# 输出
# <generator object gen at 0x0000020F6F9F5C80>
# 1
```

### **2.2.7 闭包**

> - 闭包 
>    - 闭包是一种特殊的函数，它的特点是可以访问其他函数内部的局部变量，并将该函数返回。
>    - 闭包的作用是保存函数的状态信息，使函数可以访问并操作其他函数内部的局部变量。
>    - 闭包的创建方法是在函数内部定义一个函数，并将该函数返回。
>    - 代码示例

```python
# 闭包
def outer():
    x = 1
    def inner():
        print(x)
    return inner

fn = outer()
fn()

# 输出
# 1
```

# 3 TCP-IP/HTTP

## 3.1 握手和挥手

TCP-IP协议中，握手和挥手是建立和关闭连接的过程，是网络通信中非常重要的环节。

-  三次握手<br />在建立TCP连接时，客户端和服务器之间需要进行三次握手，以确保双方都已准备好通信。<br />第一次握手：客户端发送SYN报文，请求连接。<br />第二次握手：服务器发送SYN+ACK报文，确认连接请求。<br />第三次握手：客户端发送ACK报文，确认连接建立。 
-  四次挥手<br />在关闭TCP连接时，客户端和服务器之间需要进行四次挥手，以确保双方都已关闭连接。<br />第一次挥手：客户端发送FIN报文，请求关闭连接。<br />第二次挥手：服务器发送ACK报文，确认客户端的请求。<br />第三次挥手：服务器发送FIN报文，请求关闭连接。<br />第四次挥手：客户端发送ACK报文，确认服务器的请求。 

## 3.2 流量控制和优化

TCP协议提供了流量控制和拥塞控制机制，可以有效地防止网络拥塞和数据丢失，保证网络通信的可靠性和效率。TCP协议还支持Nagle算法、延迟确认和快速重传等优化技术，可以进一步提高网络通信的性能和效率。

-  流量控制<br />TCP协议通过滑动窗口机制实现流量控制，即接收方通过通告窗口大小来限制发送方的发送速率，以防止数据丢失和网络拥塞。 
-  拥塞处理<br />TCP协议通过拥塞窗口机制实现拥塞处理，即发送方通过动态调整拥塞窗口大小来限制发送速率，以防止数据丢失和网络拥塞。 
-  参数调优<br />TCP协议的性能可以通过调整一些关键参数来进一步提高，如最大窗口大小、最大报文段长度、超时时间等。 

# 4 中间件

## 4.1 Redis
Redis是一种高性能的键值对存储系统，支持多种数据类型，如字符串、哈希、列表、集合、有序集合和地理位置信息等。Redis具有高速、可靠、灵活的特点，可以广泛地应用于缓存、消息队列、计数器、排行榜、分布式锁等场景。

-  String<br />Redis的String类型是最简单、最常用的数据类型，可以存储整数、浮点数、二进制数据等。String类型支持多种操作，如GET、SET、INCR、DECR、MSET、MGET等。 
-  Set<br />Redis的Set类型是一种无序的、不重复的数据类型，可以用于存储用户ID、IP地址、标签等数据。Set类型支持多种操作，如SADD、SREM、SMEMBERS、SINTER、SUNION等。 
-  Hash<br />Redis的Hash类型是一种键值对的集合，可以用于存储用户信息、商品信息、文章信息等数据。Hash类型支持多种操作，如HSET 
-  Sorted Set<br />Redis的Sorted Set类型是一种有序的、不重复的数据类型，可以用于存储排行榜、粉丝列表、帖子列表等数据。Sorted Set类型支持多种操作，如ZADD、ZREM、ZRANGE、ZREVRANGE等。 
-  List<br />Redis的List类型是一种有序的、可重复的数据类型，可以用于存储消息队列、任务队列、文章列表等数据。List类型支持多种操作，如LPUSH、RPUSH、LPOP、RPOP、LRANGE等。 

## 4.2 Kafka

### 4.2.1 Kafka的基本架构：
> - Broker：Kafka集群中的一台或多台服务器，用于存储和处理消息。每个Broker可以承载多个Topic的多个Partition。 
>    - Topic：消息的类别，用于对消息进行分类和区分。每个Topic由一个或多个Partition组成。
>    - Partition：Topic在物理上的分区，用于实现数据的分布和扩展。每个Partition在一个Broker上进行存储和管理。
>    - Producer：生产者，负责向Kafka中的Topic中发送消息。
>    - Consumer：消费者，负责从Kafka中的Topic中接收和处理消息。
>    - Consumer Group：多个消费者组成的逻辑上的消费者组，用于共同消费一个或多个Topic中的消息。每个消费者组中的消费者不会同时消费同一个Partition中的消息。

### 4.2.2 kafka的消息传输模型
> - Kafka的消息传输模型是基于发布-订阅模式的，Producer向Topic发送消息，Consumer从Topic中订阅消息并进行消费。消息被发送到Broker上的一个或多个Partition中，并按照Partition中的顺序进行存储，每个消息都被分配了一个唯一的偏移量。Consumer可以指定消费的偏移量，从而获取之前未被消费的消息。 
>    - 在Kafka中，Producer将消息发布（Publish）到一个或多个Topic中，而不需要关心哪些Consumer会接收这些消息。每个Topic可以被多个Producer和多个Consumer订阅（Subscribe），Producer发送的消息将被所有订阅该Topic的Consumer接收。消息在Topic中的存储和传输是基于Partition的，每个Partition的消息是有序的，并且每个Partition只能被一个Consumer消费，以实现消费的并行性和负载均衡。
>    - Consumer通过指定自己消费的Partition来消费消息，可以从Partition的开头或指定的偏移量开始消费。Consumer通过长轮询（Long Polling）方式从Broker获取消息，Broker会返回一批已经准备好的消息，Consumer对这批消息进行处理，然后提交消费偏移量（offset），以表示已经消费了这些消息。Kafka中的Consumer Group可以包含多个Consumer，多个Consumer共同消费一个或多个Topic中的消息，每个Partition中的消息只能被一个Consumer Group中的一个Consumer消费，以实现消费的协作和负载均衡。

### 4.2.3 kafka的消息存储机制

> - Kafka的消息存储机制是基于日志（Log）的。在Kafka中，每个Topic由一个或多个Partition组成，每个Partition对应一个日志文件。Producer发送的消息被追加到对应Partition的日志文件中，每个消息都有一个唯一的偏移量（Offset），用于标识消息在Partition中的位置。 
>    - Kafka的日志文件采用分段（Segment）存储的方式，每个Segment的大小可以根据需要进行配置。每个Segment包含一定数量的消息，这些消息按照时间顺序排序，较早的消息存储在前面，较新的消息存储在后面。当一个Segment已经满了，Kafka会关闭该Segment，并创建一个新的Segment来继续写入消息。旧的Segment可以被删除或归档，以释放磁盘空间。
>    - Kafka支持多副本备份（Replication）机制，每个Partition的消息可以被复制到多个Broker上，以实现数据的高可靠性。每个Partition有一个Leader和多个Follower，Producer将消息发送到Leader所在的Broker，Leader负责将消息复制到Follower中，并确认是否已经成功写入。当Leader失效时，Follower中的一个会自动升为新的Leader，以保证Partition的可用性和数据的一致性。

### 4.2.4 kafka的缺点

> - Kafka的缺点主要有以下几点： 
>    - Kafka的消息只能被消费一次，不能重复消费。
>    - Kafka的消息只能按照顺序消费，不能跳过已消费的消息。
>    - Kafka的消息只能在一定时间内消费，超过时间后消息将被删除。
>    - 配置复杂：Kafka的配置相对比较复杂，需要理解和配置多个参数，比如Partition的数量、副本数、日志保留时间等等。
>    - 存储占用较高：由于Kafka是基于日志存储的，需要保存所有的消息，因此存储占用相对比较高，特别是在数据量较大时。
>    - 数据过期问题：由于Kafka的数据是基于时间进行过期的，因此如果设置的日志保留时间过短，会导致消息过期被删除，而如果过长则会导致存储占用过高。
>    - 分区不均衡：如果分区设计不合理或者消息分布不均，会导致消费者在消费时无法实现负载均衡，某些分区的消息被消费速度较慢，导致该分区积压较多消息。
>    - 复杂性导致维护成本较高：Kafka的复杂性需要专业的团队进行维护和运营，如果没有专业人员维护，可能会出现一些意外的问题，导致系统不可用或数据丢失。

### 4.2.5 kafka的应用场景

> - kafka的应用场景主要有以下几点： 
>    - 消息队列：Kafka的最主要的应用场景是消息队列，可以用于构建高性能的分布式消息系统。
>    - 日志收集：Kafka可以用于搭建日志收集系统，将分布式系统中的日志进行收集，并统一存储，以便后续进行数据分析和挖掘。
>    - 流式处理：Kafka可以用于搭建流式处理系统，如实时计算系统、实时监控系统等。
>    - 网站行为跟踪：Kafka可以用于搭建用户行为跟踪系统，对用户的访问进行实时跟踪和分析。
>    - 消息系统：Kafka可以用于搭建分布式的消息系统，如订单系统、支付系统等，实现不同系统之间的消息通信。
>    - 日志流式处理：Kafka可以用于搭建日志流式处理系统，如日志监控系统、日志分析系统等。
>    - 离线消息处理：Kafka可以用于搭建离线消息处理系统，如离线消息分析系统等。
>    - 网站活动跟踪：Kafka可以用于搭建网站活动跟踪系统，对网站的访问进行实时跟踪和分析。
>    - 网站异常监控：Kafka可以用于搭建网站异常监控系统，对网站的异常进行实时监控和报警。

### 4.2.6 在golang中使用kafka

> - 在Golang中使用Kafka，可以通过第三方库来实现。目前比较流行的Golang Kafka客户端库包括sarama、confluent-kafka-go、shopify/sarama等。这里以sarama为例，介绍如何在Golang中使用Kafka。

```go
package main

import (
    "fmt"
    "github.com/Shopify/sarama"
)

func main() {
    config := sarama.NewConfig()
    config.Producer.RequiredAcks = sarama.WaitForAll
    config.Producer.Retry.Max = 5
    config.Producer.Return.Successes = true

    brokers := []string{"localhost:9092"}
    producer, err := sarama.NewSyncProducer(brokers, config)
    if err != nil {
        panic(err)
    }
    defer func() {
        if err := producer.Close(); err != nil {
            panic(err)
        }
    }()

    topic := "test"
    msg := &sarama.ProducerMessage{
        Topic: topic,
        Value: sarama.StringEncoder("hello world"),
    }

    partition, offset, err := producer.SendMessage(msg)
    if err != nil {
        panic(err)
    }

    fmt.Printf("Message is stored in topic(%s)/partition(%d)/offset(%d)\n", topic, partition, offset)
}
```

-  使用sarama.NewSyncProducer()方法创建了一个同步的Kafka生产者。其中，配置了Kafka的broker地址、生产者参数（等待acks确认、最大重试次数、返回成功信息）以及消息的主题和内容。使用producer.SendMessage()方法将消息发送到Kafka，并获取消息的分区和偏移量信息。 
-  除了生产者之外，sarama还提供了消费者和管理者等API，可以用于接收和处理Kafka中的消息，管理Kafka集群等操作。 

## 4.3 RabbitMQ

### 4.3.1 RabbitMQ的基本概念
> - RabbitMQ是一种开源的消息队列系统，支持多种消息协议，包括AMQP、STOMP、MQTT等。以下是RabbitMQ中的一些基本概念：

> - Broker：RabbitMQ的中心服务节点，负责消息的路由、存储和转发。多个Broker可以组成一个集群，提供高可用性和可扩展性。
> - Exchange：RabbitMQ中的消息交换机，负责接收生产者发送的消息，并根据指定的路由规则将消息路由到对应的队列。
> - Queue：RabbitMQ中的消息队列，存储消费者需要处理的消息。
> - Binding：用于将Exchange和Queue进行绑定，指定Exchange将消息路由到哪个Queue中。
> - Routing Key：路由键，是由生产者指定的消息路由关键字，Exchange根据Routing Key将消息路由到对应的Queue中。
> - Producer：消息生产者，将消息发送到Exchange。
> - Consumer：消息消费者，从Queue中获取消息并进行处理。
> - Connection：生产者和消费者与RabbitMQ Broker之间的连接，通过TCP协议进行通信。
> - Channel：RabbitMQ中的通信信道，通过Channel进行生产者和消费者与RabbitMQ之间的交互，每个Connection可以包含多个Channel。

### 4.3.2 RabbitMQ的工作模式
> - RabbitMQ的工作模式 
>    - RabbitMQ的工作模式主要有以下几种：
>    - 简单模式：一个生产者、一个消费者、一个队列。
>    - 工作模式：一个生产者、多个消费者、一个队列。
>    - 发布/订阅模式：一个生产者、多个消费者、多个队列。
>    - 路由模式：一个生产者、多个消费者、多个队列、多个路由。
>    - 主题模式：一个生产者、多个消费者、多个队列、多个路由、路由模式的增强版。
>    - RPC模式：远程过程调用模式，通过RPC实现远程过程调用。
>    - 流模式：流模式，通过流模式实现消息的流式处理。
>    - 事务模式：事务模式，通过事务实现消息的事务处理。
>    - 消息确认模式：消息确认模式，通过消息确认实现消息的可靠性投递。
>    - 消息持久化模式：消息持久化模式，通过消息持久化实现消息的可靠性投递。
>    - 消息过期模式：消息过期模式，通过消息过期实现消息的自动删除。
>    - 消息优先级模式：消息优先级模式，通过消息优先级实现消息的优先级处理。
>    - 消息死信模式：消息死信模式，通过消息死信实现消息的死信处理。
>    - 消息镜像模式：消息镜像模式，通过消息镜像实现消息的镜像处理。
>    - 消息拒绝模式：消息拒绝模式，通过消息拒绝实现消息的拒绝处理。
>    - 消息回退模式：消息回退模式，通过消息回退实现消息的回退处理。

### 4.3.3 RabbitMQ的消息确认机制
> - RabbitMQ的消息确认机制 
>    - RabbitMQ的消息确认机制主要有以下几种：
>    - 自动确认模式：自动确认模式，消息发送到Broker后，自动确认消息。
>    - 手动确认模式：手动确认模式，消息发送到Broker后，手动确认消息。
>    - 批量确认模式：批量确认模式，消息发送到Broker后，批量确认消息。
>    - 异步确认模式：异步确认模式，消息发送到Broker后，异步确认消息。
>    - 消息确认模式：消息确认模式，消息发送到Broker后，确认消息。
>    - 消息拒绝模式：消息拒绝模式，消息发送到Broker后，拒绝消息。
>    - 消息回退模式：消息回退模式，消息发送到Broker后，回退消息。
>    - 消息抓取模式：消息抓取模式，消息发送到Broker后，抓取消息。

## 4.4 Celery

### 4.4.1 Celery的基本概念
> - Celery是一个基于Python开发的分布式任务队列，支持多种消息中间件，包括RabbitMQ、Redis、MongoDB、Amazon SQS、Zookeeper等。以下是Celery中的一些基本概念： 
>    - Broker：Celery的中心服务节点，负责消息的路由、存储和转发。多个Broker可以组成一个集群，提供高可用性和可扩展性。
>    - Exchange：Celery中的消息交换机，负责接收生产者发送的消息，并根据指定的路由规则将消息路由到对应的队列。
>    - Queue：Celery中的消息队列，存储消费者需要处理的消息。
>    - Binding：用于将Exchange和Queue进行绑定，指定Exchange将消息路由到哪个Queue中。
>    - Routing Key：路由键，是由生产者指定的消息路由关键字，Exchange根据Routing Key将消息路由到对应的Queue中。
>    - Producer：消息生产者，将消息发送到Exchange。
>    - Consumer：消息消费者，从Queue中获取消息并进行处理。
>    - Connection：生产者和消费者与Celery Broker之间的连接，通过TCP协议进行通信。
>    - Channel：Celery中的通信信道，通过Channel进行生产者和消费者与Celery之间的交互，每个Connection可以包含多个Channel。
>    - Task：Celery中的任务，由生产者发送到Broker，由消费者从Broker获取并执行。
>    - Result：Celery中的任务结果，由消费者执行任务后返回给生产者。
>    - Worker：Celery中的工作节点，负责执行任务。
>    - Beat：Celery中的定时任务，负责定时发送任务到Broker。
>    - Flower：Celery中的监控工具，负责监控Celery的运行状态。
>    - App：Celery中的应用，负责管理Celery的配置信息。
>    - Task Queue：任务队列，负责存储任务。
>    - Task Result Store：任务结果存储，负责存储任务结果。
>    - Task Scheduler：任务调度器，负责调度任务。
>    - Task Worker：任务工作者，负责执行任务。
>    - Task Monitor：任务监控器，负责监控任务。
>    - Task Executor：任务执行器，负责执行任务。
>    - Task Manager：任务管理器，负责管理任务。
>    - Task Dispatcher：任务分发器，负责分发任务。
>    - Task Handler：任务处理器，负责处理任务。
>    - Task Processor：任务处理器，负责处理任务。

### 4.4.2 Celery的工作流程
> - Celery的工作流程 
>    - Celery的工作流程主要包括以下几个步骤：
>    - (1）生产者将任务发送到Broker。
>    - (2）Broker将任务存储到消息队列中。
>    - (3）消费者从Broker中获取任务。
>    - (4）消费者执行任务。
>    - (5）消费者将任务结果发送到Broker。
>    - (6）生产者从Broker中获取任务结果。
>    - (7）生产者获取任务结果。
>    - (8）生产者将任务结果返回给客户端。
>    - (9）客户端获取任务结果。
>    - (10）客户端处理任务结果。
>    - (11）客户端返回处理结果。
>    - (12）客户端获取处理结果。
>    - (13）客户端处理处理结果。

### 4.4.3 Celery的消息中间件
> - Celery的消息中间件 
>    - Celery的消息中间件主要有以下几种：
>    - RabbitMQ：RabbitMQ是一个开源的AMQP消息中间件，支持多种语言，包括Python、Java、Ruby、PHP、C#、JavaScript等。
>    - Redis：Redis是一个开源的内存数据库，支持多种数据结构，包括字符串、哈希、列表、集合、有序集合等。
>    - MongoDB：MongoDB是一个开源的NoSQL数据库，支持多种数据结构，包括文档、集合、数据库等。
>    - Amazon SQS：Amazon SQS是一个云服务，支持多种消息队列，包括标准队列、FIFO队列等。
>    - Zookeeper：Zookeeper是一个开源的分布式协调服务，支持多种数据结构，包括文件系统、列表、集合、字典等。
>    - SQLAlchemy：SQLAlchemy是一个开源的Python ORM框架，支持多种数据库，包括MySQL、PostgreSQL、Oracle、SQLite、Microsoft SQL Server等。
>    - Django ORM：Django ORM是一个开源的Python ORM框架，支持多种数据库，包括MySQL、PostgreSQL、Oracle、SQLite、Microsoft SQL Server等。
>    - Memcached：Memcached是一个开源的分布式内存缓存系统，支持多种数据结构，包括字符串、哈希、列表、集合、有序集合等。

### 4.4.4 Celery在Python中使用
> - Celery在Python中使用
> - Celery在Python中使用主要包括以下几个步骤：
> - (1）安装Celery。
> - (2）创建Celery应用。
> - (3）创建任务。
> - (4）启动Celery应用。
> - (5）发送任务。
> - (6）执行任务。
> - (7）获取任务结果。
> - (8）处理任务结果。

