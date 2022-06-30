---
layout: mypost
title: 算法和数据结构(Python)
categories: [Algorithm, Python]
---

# 快速排序
> 快速排序使用分治法（Divide and conquer）策略来把一个序列（list）分为较小和较大的2个子序列，然后递归地排序两个子序列。
  步骤为：
> + 挑选基准值：从数列中挑出一个元素，称为"基准"（pivot）;
> + 分割：重新排序数列，所有比基准值小的元素摆放在基准前面，所有比基准值大的元素摆在基准后面（与基准值相等的数可以到任何一边）。在这个分割结束之后，对基准值的排序就已经完成;
> + 递归排序子序列：递归地将小于基准值元素的子序列和大于基准值元素的子序列排序。
> + 递归到最底部的判断条件是数列的大小是零或一，此时该数列显然已经有序。

[comment]: <> (> + ![https://pic.leetcode-cn.com/d13bd82917a8eba049efa261bebd3beb74b9e7c1adf39ce51bf1c9dd60d49f57-Quicksort-example.gif]&#40;https://pic.leetcode-cn.com/d13bd82917a8eba049efa261bebd3beb74b9e7c1adf39ce51bf1c9dd60d49f57-Quicksort-example.gif&#41;)

[comment]: <> (> + ![https://pic.leetcode-cn.com/e9ca22f1693e33a2fef64f55c10096ec93b9466459937f69eb409b0dad3f55bd-849589-20171015230936371-1413523412.gif]&#40;https://pic.leetcode-cn.com/e9ca22f1693e33a2fef64f55c10096ec93b9466459937f69eb409b0dad3f55bd-849589-20171015230936371-1413523412.gif&#41;)

```python
l = [3,1,5,2,8,5,9,4,7,3]
def QuickSort(nums: list) -> list:
    if len(nums) < 2:
        return nums
    else:
        top = nums[0] # 主元
        left = [lg for lg in nums[1:] if lg<top] # 主元左侧的元素
        right = [lg for lg in nums[1:] if lg>=top] # # 主元左侧的元素
        nums = QuickSort(left) + [top] + QuickSort(right)
        return nums

print(QuickSort(l))


```

# 选择排序
> + 首先在未排序序列中找到最小（大）元素，存放到排序序列的起始位置，
> + 然后，再从剩余未排序元素中继续寻找最小（大）元素，然后放到已排序序列的末尾。以此类推，直到所有元素均排序完毕。

[comment]: <> (> + ![https://pic.leetcode-cn.com/3b5a9383650b7ba01211846defeda8917d78827f02132113c57fcbd09715bf4b-849589-20171015224719590-1433219824.gif]&#40;https://pic.leetcode-cn.com/3b5a9383650b7ba01211846defeda8917d78827f02132113c57fcbd09715bf4b-849589-20171015224719590-1433219824.gif&#41;)

```python
l = [3,1,5,2,8,5,9,4,7,3]
def SelectedSort(nums: list) -> list:
    if len(nums) <= 1:
        return nums
    else:
        n = len(nums)
        for i in range(n):
            for j in range(i, n):
                if nums[j] > nums[i]:
                    nums[j], nums[i] = nums[i], nums[j]
        return nums

print(SelectedSort(l))
```

# 冒泡排序（Bubble Sort）
> 冒泡排序时针对相邻元素之间的比较，可以将大的数慢慢“沉底”(数组尾部)
> + 所谓冒泡，就是将元素两两之间进行比较，谁大就往后移动，直到将最大的元素排到最后面，
> + 接着再循环一趟，从头开始进行两两比较，而上一趟已经排好的那个元素就不用进行比较了。

[comment]: <> (> + ![https://pic.leetcode-cn.com/faa1a3c1b3f1ae8a406e9c8e86bd28a9a1fb621ed6cc8eead1fe6e14ee0ec1c4-v2-d4c88b8cc620af6af67c33910899fcf7_b.gif]&#40;https://pic.leetcode-cn.com/faa1a3c1b3f1ae8a406e9c8e86bd28a9a1fb621ed6cc8eead1fe6e14ee0ec1c4-v2-d4c88b8cc620af6af67c33910899fcf7_b.gif&#41;)

[comment]: <> (> + ![https://pic.leetcode-cn.com/7d9af5dcad63d4097876f2614f38484f49b4e34f75c296a75001b19cf8134bb4-849589-20171015223238449-2146169197.gif]&#40;https://pic.leetcode-cn.com/7d9af5dcad63d4097876f2614f38484f49b4e34f75c296a75001b19cf8134bb4-849589-20171015223238449-2146169197.gif&#41;)

```python
"""
# 其实直白讲 冒泡排序就是元素两两比较，找出每一轮中最大的元素放到尾部  [3, 1, 5, 2, 8, 5, 9, 7, 4]
# 比如上面这个列表 3先和1比较 3>1 二者互换位置 也就是 [1, 3, 5, 2, 8, 5, 9, 7, 4]
# 然后3和5比较 3<5 所以不变 还是 [1, 3, 5, 2, 8, 5, 9, 7, 4] 以此类推
for j in range(0, len(nums))
if nums[j] > nums[j+1]: 如果前者大于后者 二者互换位置
    nums[j], nums[j+1] = nums[j+1], nums[j]
    
"""

# 第一个版本
from typing import List
def BubbleSort(nums: List) -> List:
    n = len(nums)
    if n <= 1:
        return nums
    else:
        for i in range(n-1):
          for j in range(i, n-1-i): # 每一次循环都是建立在上一次循环的基础上 每次减i
            if nums[j] > nums[j+1]:
                nums[j], nums[j+1] = nums[j+1], nums[j]
        return nums
```

> 上面的这个版本这是冒泡排序最普通的写法，但你会发现它有一些不足之处，
> + 比如列表：[1,2,3,4,7,5,6]，第一次循环将最大的数排到最后，此时列表已经都排好序了，就是不用再进行第二次、第三次..

```python
# 第二个版本 优化版 
""" 
    可以设置一个变量flag=false打标记，如果元素之间交换了位置，就将flag置为true，
    最后再判断，如果一次循环下来，变量还是false，就结束循环 说明全部都是有序的
"""
from typing import List
def BubbleSort(nums: List) -> List:
    n = len(nums)
    if n <= 1:
        return nums
    else:
        for i in range(n-1):
            flag = False
            for j in range(i, n-i-1):
                if nums[j] > nums[j+1]:
                    nums[j], nums[j+1] = nums[j+1], nums[j]
                    flag = True
            if not flag:
                break
        return nums
```

> 第三个版本 双向排序
> + 上面这种写法还有一个问题，就是每次都是从左边到右边进行比较，这样效率不高，你要考虑当最大值和最小值分别在两端的情况。 
> + 写成双向排序提高效率，即当一次从左向右的排序比较结束后，立马从右向左来一次排序比较。

```python
# 第三个版本 双向排序
from typing import List
def BubbleSort(nums: List) -> List:
    n = len(nums)
    if n <= 1:
        return nums
    else:
        for i in range(n-1):
            flag = False
            for j in range(i, n-i-1):
                if nums[j] > nums[j+1]:
                    nums[j], nums[j+1] = nums[j+1], nums[j]
                    flag = True
            if flag:
                flag = False
                for j in range(n-i-2, 0, -1):
                    if nums[j] < nums[j-1]:
                        nums[j], nums[j-1] = nums[j-1], nums[j]
                        flag = True
            if not flag:
                break
        return nums
```

> 最后要考虑的情况就是，如果给你的不是列表，而是对象，或者列表里面都是字符串，那么上述的代码也就没有用了，
> + 这时候你就要自定义函数了，并将其当成参数传入bubble_sort函数

```python
from typing import List
def BubbleSort(nums: List, comp=lambda x, y: x > y) -> List:
    if len(nums) < 2:
        return nums
    else:
        n = len(nums)
        for i in range(n - 1):
            flag = False
            for j in range(i, n - i - 1):
                if comp(nums[j], nums[j + 1]):
                    nums[j], nums[j + 1] = nums[j + 1], nums[j]
                    flag = True
            if flag:
                flag = False
                for j in range(n--i-2, 0, -1):
                    if comp(nums[j-1], nums[j]):
                        nums[j], nums[j-1] = nums[j-1], nums[j]
                        flag = True
            if not flag:
                break
        return nums
l = ['apple', 'watermelon', 'pitaya', 'waxberry', 'pear']
# 按照字符串长度从小到大来排序
print(BubbleSort(l, lambda x,y:len(x)>len(y))) # ['pear', 'apple', 'pitaya', 'waxberry', 'watermelon']

# 类似的，当有人叫你给一个类对象排序时，也可以传入lambda 自定义函数。
class Student():
    """学生"""
 
    def __init__(self, name, age):
        self.name = name
        self.age = age
 
    def __repr__(self):
        return f'{self.name}: {self.age}'
 
items1 = [
        Student('Wang Dachui', 25),
        Student('Di ren jie', 38),
        Student('Zhang Sanfeng', 120),
        Student('Bai yuanfang', 18)
    ]
# 按照年龄从小到大排序
print(BubbleSort(items1, lambda s1, s2: s1.age > s2.age)) # [Bai yuanfang: 18, Wang Dachui: 25, Di ren jie: 38, Zhang Sanfeng: 120]
```

# 插入排序
> 插入排序（英语：Insertion Sort）
> + 它的工作原理是通过构建有序序列，对于未排序数据，在已排序序列中从后向前扫描，找到相应位置并插入。
> + 插入排序在实现上，在从后向前扫描过程中，需要反复把已排序元素逐步向后挪位，为最新元素提供插入空间。
> + 插入排序主要是将列表分为两部分，左边为已经插入排好序的，右边是待排序的。
> + 每次从右边依次拿一个到左边寻找合适的位置插入，在左边（有序序列）寻找合适位置时其实就是一次循环。

[comment]: <> (> + ![https://upload-images.jianshu.io/upload_images/14356854-cb5f2b8e9cf2962c.gif?imageMogr2/auto-orient/strip|imageView2/2/w/300/format/webp]&#40;https://upload-images.jianshu.io/upload_images/14356854-cb5f2b8e9cf2962c.gif?imageMogr2/auto-orient/strip|imageView2/2/w/300/format/webp&#41;)

```python
from typing import List
def InsertionSort(nums: List) -> List:
    for i in range(1, len(nums)):
        j = i
        while j > 0 and nums[j] < nums[j-1]:
            nums[j], nums[j-1] = nums[j-1], nums[j]
            j -= 1
    return nums
```

# 
```python

```

# 

# LRUCache算法
> Least-Recently-Used 替换掉最近最少使用的对象
> + 缓存剔除策略,当缓存空间不够用的时候需要一种方式剔除key
> + 常见的有LRU, LFU等
> + LRU通过使用一个循环双端队列不断把最新访问的key放到表头实现
> + 字典用来缓存，循环双端链表用来记录访问顺序

> 利用python内置的dict + collections.OrderedDict实现
> + dict 用来当作k/v键值对的缓存
> + OrderedDict用来实现更新最近访问的key

```python
from collections import OrderedDict
class LRUCache:
    def __init__(self, capacity=128):
        self.od = OrderedDict()
        self.capacity = capacity

    def get(self, key):  # 每次访问更新最新使用的key
        # 由于用OrderedDict来存取最近访问的key
        if key not in self.od:
            return -1
        if key in self.od:
            val = self.od[key]
            self.od.move_to_end[key]
            return val

    def put(self, key, value):  # 更新k/v
        if key not in self.od:  # insert
            self.od[key] = value
            # 判断容量是否已满
            if len(self.od) > self.capacity:
                self.od.popitem(last=False)
        del self.od[key]
        self.od[key] = value  # 更新key到表头
```
