---
layout: mypost
title:       "Azure IotHub Golang开发指北"
subtitle:    "Azure IotHub"
description: "Azure IotHub Golang开发指北"
date:        2022-01-05
author:      "Tomtao626"
image:       ""
tags:        ["Cloud", "Tools", "Tips"]
categories:  ["Cloud", "Golang]
---

# 1-Azure IotHub 开发配置

## 1.1 在Azure Portal上创建Azure IotHub

## 1.2 在Iot中心为存储账户和服务总线队列配置终结点和消息路由

> + 进入`iothub`配置界面，选择左侧的消息路由，点击新增(说直白点就是，设备上报的数据直接存储在service bus中)
> + 设置名称、终结点、消息来源默认、剩下选项默认
+ > a.新增一个终结点-service bus (queen/topic) endpoint类型
  > + 选择不同的endpoint类型，将会把数据持久化到不同的节点里面
  > + 消息终结点有`Event hubs`/`service bus queue`/`service bus topic`/`Storage`四种类型,这种我们使用`service bus topic`
  > + 这里需要区分下 `queen`和`topic`，`queen`是一个队列，`topic`是一个主题
  > + 队列为一个或多个竞争使用方提供先入先出 (`FIFO`) 消息传递方式。 也就是说，接收方通常会按照消息添加到队列中的顺序来接收并处理消息。 并且每条消息仅由一个消息使用方接收并处理。 使用队列的主要优点是实现应用程序组件的临时分离。 换句话说，创建方（发送方）和使用方（接收方）不必同时发送和接收消息。 这是因为消息已持久存储在队列中。 此外，创建方不必等待使用方的答复即可继续处理并发送更多消息。
  > + 队列允许单个使用方处理消息。 与队列不同，主题和订阅以“发布和订阅”模式提供一对多的通信形式。 这对于扩展到大量接收方而言十分有用。 每个发布的消息均可用于向该主题注册的每个订阅。 发布方将消息发送到主题，一个或多个订阅服务器将接收该消息的副本，具体取决于对这些订阅设置的筛选规则。 此订阅可以使用其他筛选器来限制其想要接收的消息。 发布方将消息发送到主题的方式与将消息发送到队列的方式相同。 但使用方不会直接从主题接收消息。 相反，使用方从该主题的订阅接收消息。 主题订阅类似于接收发送至该主题的消息副本的虚拟队列。 使用方从订阅接收消息的方式与从队列接收消息的方式相同。
+ > b.需要设置endpoint名称，添加与此IoT中心共享订阅的已存在的service bus (queen/topic)，若没有，就需要新建service bus和对应的topic（见在 [azure service bus 配置](#1)），其他内容默认。
> + 点击创建

## 1.3 在设备中配置终结点和消息路由

# <div id="1">2.azure service bus 配置</div>

## 2.1 在 Azure 门户中创建命名空间

### 若要开始在 Azure 中使用服务总线消息实体，必须先使用在 Azure 中唯一的名称创建一个命名空间。 命名空间提供了用于对应用程序中的 Service Bus 资源进行寻址的范围容器。
  
> 在“创建命名空间”页的“基本信息”标记中，执行以下步骤 ：

> + a.对于“订阅”，请选择要在其中创建命名空间的 Azure 订阅。
> + b.对于“资源组”，请选择该命名空间驻留到的现有资源组，或创建一个新资源组。
> + c.输入命名空间的名称。 命名空间名称应遵循以下命名约定：
>   + 该名称在 Azure 中必须唯一。 系统会立即检查该名称是否可用。
>   + 名称长度最少为 6 个字符，最多为 50 个字符。
>   + 名称只能包含字母、数字、连字符“-”。
>   + 名称必须以字母开头，并以字母或数字结尾。
>   + 名称不以“-sb”或“-mgmt”结尾。
>   + 对于“位置”，请选择托管该命名空间的区域。
> + d.对于“定价层”，请选择命名空间的定价层（“基本”、“标准”或“高级”）。 对于本快速入门，请选择“标准”。
> + e.若要使用[主题和订阅](https://docs.microsoft.com/zh-cn/azure/service-bus-messaging/service-bus-queues-topics-subscriptions#topics-and-subscriptions)，请选择“标准”或“高级”。 基本定价层不支持主题/订阅。 如果选择了“高级”定价层，请指定“消息传送单元”数 。 高级层在 CPU 和内存级别提供资源隔离，使每个工作负荷在隔离的环境中运行。 此资源容器称为消息传送单元。 高级命名空间至少具有一个消息传送单元。 可为每个服务总线高级命名空间选择 1、2、4、8 或 16 个消息传送单元。 有关详细信息，请参阅[服务总线高级消息传送](https://docs.microsoft.com/zh-cn/azure/service-bus-messaging/service-bus-premium-messaging)。
> + f.选择“查看 + 创建” 。 系统现已创建命名空间并已将其启用。 可能需要等待几分钟，因为系统将为帐户配置资源。

## 2.2 获取连接字符串

### 创建新的命名空间会自动生成一个初始共享访问签名 (SAS) 策略，该策略包含主密钥和辅助密钥以及主要连接字符串和辅助连接字符串，每个连接字符串都授予对命名空间所有方面的完全控制权。 请参阅[服务总线身份验证和授权](https://docs.microsoft.com/zh-cn/azure/service-bus-messaging/service-bus-authentication-and-authorization)，了解如何创建规则来对普通发送者和接收者的权限进行更多限制。

> 若要复制命名空间的主要连接字符串，请执行以下步骤：

> + a.在“服务总线命名空间”页中的左侧菜单上，选择“共享访问策略” 。
> + b.在“共享访问策略”页，选择“RootManageSharedAccessKey” 。
> + c.在“策略: RootManageSharedAccessKey”窗口中，单击“主连接字符串”旁边的复制按钮，将连接字符串复制到剪贴板供稍后使用 。 将此值粘贴到记事本或其他某个临时位置。可使用此页面复制主密钥、辅助密钥和辅助连接字符串。

## 2.3 在 Azure 门户中创建队列

> + 在“服务总线命名空间”页面上，选择左侧导航菜单中的“队列”。
> + 在“队列”页面上，选择工具栏上的“+ 队列”。
> + 输入队列名称，其他值则保留默认值。选择“创建”。

## 2.4 在已创建的Service Bus空间中，创建topic(主题)

> + a.输入topic名称，最大空间，留存(过期)时间，点击创建
> + b.点击刚创建的topic，再次选择subscriptions(订阅)新建。(创建对主题的订阅)
> + c.可以创建多个对主题的订阅

# 3 Azure 内需要开通的服务

> + azure iot hub
> + Azure IoT 中心设备预配服务
> + azure service bus
> + azure storage(Blob如果需要)

## 3.1 Azure Iot 配置流程

> + azure dps服务设备预配
> + 设备注册到iothub
> + 设备控制
>   + 设备上报(D2C)
>   + 设备接收(C2D)
>   + 直接方法调用(InvokeDirectMethod)
>   + 设备孪生

## 3.2 设备重新连接流

> + IoT 中心不会保留已断开连接设备的所需属性更新通知。 它遵循的原则是：连接的设备必须检索整个所需属性文档，此外还要订阅更新通知。 如果更新通知与完全检索之间存在资源争用的可能性，则必须确保遵循以下流：
>  + 设备应用连接到 IoT 中心。
>  + 设备应用订阅所需属性更新通知。
>  + 设备应用检索所需属性的完整文档。
> + 设备应用可以忽略 $version 小于或等于完全检索文档的版本的所有通知。 之所以能够使用此方法，是因为 IoT 中心保证版本始终是递增的

## 3.2 后端服务配置设备流程

![](https://docs.microsoft.com/zh-cn/azure/iot-hub/media/tutorial-device-twins/devicetwins.png)
> + 创建 IoT 中心并将测试设备添加到标识注册表。(设备注册到IotHub)
> + 使用所需属性将状态信息发送到模拟设备。(设备控制)
> + 使用报告属性从模拟设备接收状态信息。(服务接收)

# 4 Azure IoT 中心设备预配服务

## 4.1 什么是预配

> IoT 中心设备预配服务 (DPS) 是 IoT 中心的帮助器服务，支持零接触、实时预配到适当的 IoT 中心，不需要人为干预。 使用 DPS 能够以安全且可缩放的方式预配数百万台设备。

## 4.2 预配流程

> ![](https://docs.microsoft.com/zh-cn/azure/iot-dps/media/about-iot-dps/dps-provisioning-flow.png)
> + 1.设备制造商将设备注册信息添加到 Azure 门户中的注册列表。
> + 2.设备联系工厂中设置的 DPS 终结点。 设备将标识信息传递给 DPS 来证明其身份。
> + 3.DPS 通过使用 nonce 质询（受信任的平台模块）或标准 X.509 验证 (X.509) 根据注册列表项来验证注册 ID 和密钥，从而验证设备的标识。
> + 4.DPS 将设备注册到 IoT 中心，并填充设备的所需孪生状态。
> + 5.IoT 中心将设备 ID 信息返回给 DPS。
> + 6.DPS 将 IoT 中心连接信息返回给设备。 设备现在可以开始将数据直接发送到 IoT 中心。
> + 7.设备连接到 IoT 中心。
> + 8.设备从其在 IoT 中心中的设备孪生获取所需的状态。

## 4.3 设备预配服务的功能

> DPS 具有许多功能，非常适合用于预配设备。
> + 对基于 X.509 和 TPM 的标识 的安全证明支持。
> + 注册列表，其中包含可能在某一时刻注册的设备/设备组的完整记录 。 注册列表包含有关设备注册后所需的设备配置信息，并可随时更新。
> + 多个分配策略，用于根据自己的需要控制 DPS 向 IoT 中心分配设备的方式：通过注册列表控制最小延迟、平均加权分布（默认值）和静态配置。 延迟是使用与流量管理器相同的方法确定的。
> + 监视和诊断日志记录，用于确保一切都正常工作。
> + 多中心支持，允许 DPS 将设备分配给多个 IoT 中心。 DPS 可以跨多个 Azure 订阅来与中心通信。
> + 跨区域支持使 DPS 能够将设备分配到其他区域的 IoT 中心。
> + 静态数据加密允许使用 256 位 AES 加密（可用的最强大的分组加密法之一，并且符合 FIPS 140-2）透明地加密和解密 DPS 中的数据。
可以通过查看 [DPS 术语](https://docs.microsoft.com/zh-cn/azure/iot-dps/concepts-service)主题以及同一部分的其他概念性主题来详细了解设备预配中涉及的概念和功能。

## 4.4 跨平台支持

>与所有 Azure IoT 服务一样，DPS 可以在各种操作系统上跨平台运行。 Azure 采用各种语言提供了开放源 SDK，以便于连接设备并管理服务。 DPS 支持使用以下协议来连接设备：
> + HTTPS
> + AMQP
> + 基于 Web 套接字的 AMQP
> + MQTT
> + 基于 Web 套接字的 MQTT

> DPS 仅支持使用 HTTPS 连接来执行服务操作。

## 4.5 配额和限制

> 每个 Azure 订阅附带默认的配额限制，这些限制可能影响 IoT 解决方案的范围。 每个订阅的当前限制是每订阅 10 个设备预配服务。

> 适用于 Azure IoT 中心设备预配服务资源的限制。

| 资源	                   | 限制         | 	可调？ |
|-----------------------|------------|------|
| 每个 Azure 订阅的最大设备预配服务数 | 	10        | 	是   |
| 最大注册数	                | 1,000,000	 | 是    |
| 单个注册的最大数目             | 	1,000,000 | 	是   |
| 注册组的最大数目（X.509 证书）    | 	100	      | 是    |
| 注册组的最大数目（对称密钥）	       | 100	       | 否    |
| 最大 CA 数               | 	25	       | 否    |
| 链接的 IoT 中心的最大数量       | 	50        | 	否   |
| 消息的最大大小	              | 96 KB      | 	否   |

> 设备预配服务具有以下速率限制。

| 费率	         | 每单位值       | 可调？ |
|-------------|------------|-----|
| Operations	 | 200/分钟/服务  | 是   |
| 设备注册数	      || 200/分钟/服务	 |是|
| 设备轮询操作	     | 5/10 秒/设备	 | 否   |

## 4.6 计费服务操作和定价

> DPS上的每个API调用都会作为一个操作来计费

| API              | 操作           | 是否计费？ |
|------------------|--------------|-------|
| 设备 API           | 设备注册状态查找	    | 否     |
| 设备 API           | 操作状态查找	      | 否     |
| 设备 API           | 注册设备	        | 是     |
| DPS 服务 API（注册状态） | 删除	          | 是     |
| DPS 服务 API（注册状态） | Get          | 	是    |
| DPS 服务 API（注册状态） | 查询	          | 是     |
| DPS 服务 API（注册组）  | 创建或更新	       | 是     |
| DPS 服务 API（注册组）  | 删除	          | 是     |
| DPS 服务 API（注册组）  | Get	         | 是     |
| DPS 服务 API（注册组）  | 获取证明机制	      | 是     |
| DPS 服务 API（注册组）  | 查询	          | 是     |
| DPS 服务 API（注册组）  | 运行批量操作	      | 是     |
| DPS 服务 API（单个注册） | 创建或更新	       | 是     |
| DPS 服务 API（单个注册） | 删除	          | 是     |
| DPS 服务 API（单个注册） | Get	         | 是     |
| DPS 服务 API（单个注册） | 获取证明机制	      | 是     |
| DPS 服务 API（单个注册） | 查询	          | 是     |
| DPS 服务 API（单个注册） | 运行批量操作	      | 是     |
| DPS 证书 API       | 创建或更新        | 否     |
| DPS 证书 API       | 删除	          | 否     |
| DPS 证书 API       | 生成验证码	       | 否     |
| DPS 证书 API       | Get	         | 否     |
| DPS 证书 API       | 列表	          | 否     |
| DPS 证书 API       | 验证证书	        | 否     |
| IoT DPS 资源 API   | 检查预配服务名称可用性	 | 否     |
| IoT DPS 资源 API   | 创建或更新	       | 否     |
| IoT DPS 资源 API   | 删除	          | 否     |
| IoT DPS 资源 API   | Get	         | 否     |
| IoT DPS 资源 API   | 获取操作结果	      | 否     |
| IoT DPS 资源 API   | 按资源组列表	      | 否     |
| IoT DPS 资源 API   | 按订阅列出	       | 否     |
| IoT DPS 资源 API   | 按键列出	        | 否     |
| IoT DPS 资源 API   | 列出密钥名称的密钥	   | 否     |
| IoT DPS 资源 API   | 列出有效 SKU	    | 否     |
| IoT DPS 资源 API   | 更新	          | 否     |

## 4.7 设备预配示例

### 4.7.1 创建单个注册

#### 4.7.1-1 API详情

> + Individual Enrollment - Create Or Update
>   + URL： https://your-dps.azure-devices-provisioning.net/enrollments/{id}?api-version=2021-06-01
>   + Service：IoT Hub Device Provisioning Service
>   + API Version：2021-06-01
>   + Method：PUT
>   + RequestHeader：
>     + Content-Type:application/json
>     + Authorization:""

#### 4.7.1-1 URI 参数

| Name        | 	In	   | Required | 	Type  | 	Description                      |
|-------------|--------|----------|--------|-----------------------------------|
| id	         | path   | True     | string | 注册 ID 是小写的字母数字，并且可包含连字符。          |
| api-version | 	query | True     | string | 要用于请求的 API 版本。 支持的版本包括：2021-06-01 |

#### 4.7.1-2 请求正文

| Name	                       | Required	 | Type	                                                     | Description                                                                                                                                                                                                                                                                                    |
|-----------------------------|-----------|-----------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| attestation	                | True      | AttestationMechanism                                      | 设备使用的证明方法。                                                                                                                                                                                                                                                                                     |
| registrationId	             | True      | string                                                    | 注册 ID 是小写的字母数字，并且可包含连字符。                                                                                                                                                                                                                                                                       |
| allocationPolicy	           | 	         | enum: <br/>hashed <br/>geoLatency <br/>static <br/>custom | 此资源的分配策略。 此策略覆盖此单个注册组或注册组的租户级别分配策略。 可能的值包括 "哈希"：链接的 IoT 中心可能会将设备预配到设备 "geoLatency"：将设备预配到具有最低延迟的 IoT 中心。如果多个链接的 IoT 中心提供相同的最低延迟，则预配服务会在这些中心中对设备进行哈希处理： "静态"：注册列表中所需 IoT 中心的规范优先于服务级别分配策略，"自定义"：根据自己的自定义逻辑将设备预配到 IoT 中心。 预配服务将有关设备的信息传递给逻辑，逻辑返回所需的 IoT 中心以及所需的初始配置。 建议使用 Azure Functions 来托管逻辑。 |
| capabilities	               | 	         | DeviceCapabilities                                        | 设备的功能。                                                                                                                                                                                                                                                                                         |
| customAllocationDefinition  | 		        | CustomAllocationDefinition                                | 这会告知 DPS 使用自定义分配时要调用的 webhook。                                                                                                                                                                                                                                                                 |
| deviceId	                   | 	         | string                                                    | 所需的 IoT 中心设备 ID (可选) 。                                                                                                                                                                                                                                                                         |
| etag	                       | 	         | string                                                    | 与资源关联的实体标记。                                                                                                                                                                                                                                                                                    |
| initialTwin		               |           | InitialTwin                                               | 初始设备克隆。                                                                                                                                                                                                                                                                                        |
| iotHubHostName		            |           | string                                                    | Iot 中心主机名。                                                                                                                                                                                                                                                                                     |
| iotHubs		                   |           | string[]                                                  | IoT 中心主机名，可以将此资源中 () 的设备分配到该列表。 必须是 IoT 中心的租户级别列表的子集。                                                                                                                                                                                                                                          |
| optionalDeviceInformation		 |           | TwinCollection                                            | 可选的设备信息。                                                                                                                                                                                                                                                                                       |
| provisioningStatus		        |           | enum: <br/>enabled <br/>disabled                          | 预配状态。                                                                                                                                                                                                                                                                                          |
| reprovisionPolicy		         |           | ReprovisionPolicy                                         | 将设备重新预配到 IoT 中心时的行为。                                                                                                                                                                                                                                                                           |

#### 4.7.1-3 代码示例

```golang
package main

import (
	"bytes"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"strconv"
	"time"
)

type DevProvisionStu struct {
	Attestation struct {
		Type string `json:"type"`
	} `json:"attestation"`
	RegistrationId string `json:"registrationId"`
}

func Base64Decode(src string) []byte {
	dst, err := base64.StdEncoding.DecodeString(src)
	if err != nil {
		return nil
	}
	return dst
}

// 生成DPS校验参数
func geneDpsSign() string {
	sharekey := "ABCDEFGYtIQlg7R68Od6xwZ49nOs/srIaOT/9EUW0m0="
	policyName := "provisioningserviceowner"
	endpoint := "global.azure-devices-provisioning.cn"
	expires := time.Now().Unix() + 3600

	signstr := fmt.Sprintf("%s\n%d", endpoint, expires)

	signkey := Base64Decode(sharekey)

	h := hmac.New(sha256.New, signkey)
	h.Write([]byte(signstr))
	token := base64.StdEncoding.EncodeToString(h.Sum(nil))

	params := url.Values{}
	params.Add("sr", endpoint)
	params.Add("sig", token)
	params.Add("se", strconv.FormatInt(expires, 10))
	params.Add("skn", policyName)

	return fmt.Sprintf("SharedAccessSignature %s", params.Encode())
}

func createDevRecords(registrationId string) (respby []byte, statuscode int, err error) {
	var upsertUrl = "https://%s/enrollments/%s?api-version=2021-06-01"
	DevProvisonEndPoint := "tomtao626.azure-devices-provisioning.cn"
	reqUrl := fmt.Sprintf(upsertUrl, DevProvisonEndPoint, registrationId)

	var reqbody DevProvisionStu
	reqbody.Attestation.Type = "symmetricKey"
	reqbody.RegistrationId = registrationId

	reqBytes, _ := json.Marshal(reqbody)
	reader := bytes.NewReader(reqBytes)
	client := &http.Client{}

	req, err := http.NewRequest("PUT", reqUrl, reader)
	if err != nil {
		log.Fatal(err.Error())
		return
	}
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", geneDpsSign())

	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		return
	}

	defer resp.Body.Close()
	respby, err = ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
		return
	}

	statuscode = resp.StatusCode

	return
}

func main() {
	backResp, statusCode, err := createDevRecords("registerid")
	if err != nil {
		panic(err)
		return
	}

	if statusCode != http.StatusOK {
		panic(err)
		return
	}
	fmt.Println(backResp)
}
```

#### 4.7.1-2 接口返回

> + API接口调用成功会返回设备对应的：

| Name	        | Type	  | Description |
|--------------|--------|-------------|
| primaryKey   | string | 主对称密钥。      |
| secondaryKey | string | 辅助对称密钥。     |
| etag         | string | 与资源关联的实体标记。 |

```json
{
  "attestation": {
    "symmetricKey": {
      "primaryKey": "fv01m6+msmBJSfsFYpvmVlFLfLBvOczjgztrH9eMP8keIU/11+br2FDsN7OamSJ4nQJE38W6zsWmXfBmwb0qYI/A==",
      "secondaryKey": "Ut+NK3VBuo3sfs6I0H7SOn3td3BfvY+OBPSmV3mtLRtLmFrpOIXP7Q1jNhGmch2wy/LziiJ2FGuf23NZMd+9zl3CA=="
    }
  },
  "etag": "dsfdsfds23456789qazdfksnfksnfksdsf"
}
```

> + `RegistrationId`/`PrimaryKey`/`SecondaryKey`三个参数在后面的设备注册到`iothub`和设备控制都需要使用

### 4.7.2 设备注册

#### 4.7.2-1 API详情

> + Runtime Registration - Register Device
>   + URL： https://global.azure-devices-provisioning.net/{idScope}/registrations/{registrationId}/register?api-version=2021-06-01
>   + Service：IoT Hub Device Provisioning Service
>   + API Version：2021-06-01
>   + Method：PUT
>   + RequestHeader：
      >     + Content-Type:application/json
>     + Authorization:""

#### 4.7.2-2 URI 参数

| Name            | 	In	   | Required | 	Type  | 	Description                      |
|-----------------|--------|----------|--------|-----------------------------------|
| idScope         | path   | True     | string ||
| registrationId	 | path   | 	  True  | string | 注册 ID 是小写的字母数字，并且可包含连字符。          |
| api-version     | 	query | 	True    | string | 要用于请求的 API 版本。 支持的版本包括：2021-06-01 |

#### 4.7.2-3 请求正文
| Name	          | Type	          | Description                                                            |
|----------------|----------------|------------------------------------------------------------------------|
| payload        | object         | 自定义分配有效负载。                                                             |
| registrationId | string         | 注册 ID 是不区分大小写的字符串， (最多 128 个字符长) 字母数字字符加上某些特殊字符： _ -. 在开头或结尾不允许使用特殊字符。 |
| tpm            | TpmAttestation | Tpm。                                                                   |

#### 4.7.2-4 代码示例

```go
package main

import (
  "bytes"
  "crypto/hmac"
  "crypto/sha256"
  "encoding/base64"
  "encoding/json"
  "fmt"
  "io/ioutil"
  "log"
  "net/http"
  "net/url"
  "strconv"
  "strings"
  "time"
)

type DevProvisionStu struct {
  RegistrationId string `json:"registrationId"`
}

type RegistRespStu struct {
  OperationId string `json:"operationId"`
  Status      string `json:"status"`
}

func Base64Decode(src string) []byte {
  dst, err := base64.StdEncoding.DecodeString(src)
  if err != nil {
    return nil
  }
  return dst
}

func geneDeviceSign() string {
  primaryKey := "" // 从iothub获取
  policyName := "registration"
  idscope := "0cn000346C6"
  registrationid := "20210623device05"
  uri := fmt.Sprintf("%s/registrations/%s", idscope, registrationid)
  expires := time.Now().Unix() + 3600

  signstr := fmt.Sprintf("%s\n%d", url.QueryEscape(uri), expires)
  signkey := Base64Decode(primaryKey)

  h := hmac.New(sha256.New, signkey)
  h.Write([]byte(signstr))
  token := base64.StdEncoding.EncodeToString(h.Sum(nil))

  params := url.Values{}
  params.Add("sr", uri)
  params.Add("sig", token)
  params.Add("se", strconv.FormatInt(expires, 10))
  params.Add("skn", policyName)
  log.Fatalf("Authorization:----", fmt.Sprintf("SharedAccessSignature %s", params.Encode()))
  return fmt.Sprintf("SharedAccessSignature %s", params.Encode())
}

func ParseResponseString(response *http.Response) (string, error) {
  //var result map[string]interface{}
  body, err := ioutil.ReadAll(response.Body) // response.Body 是一个数据流
  return string(body), err                   // 将 io数据流转换为string类型返回！
}

func main() {
  log.Fatal("DeviceRegToIot()----设备注册到IotHub")
  baseUrl := fmt.Sprintf("https://%s", "global.azure-devices-provisioning.cn")
  idScope := "0cn000346C6"
  registrationId := "20210621device01"
  regBaseUrl := "tomtao626.azure-devices.cn"
  reqUrl := fmt.Sprintf(regBaseUrl, baseUrl, idScope, registrationId)
  log.Fatal("设备信息, Reg请求Url", registrationId, reqUrl)
  var reqBody DevProvisionStu
  reqBody.RegistrationId = registrationId
  reqBytes, _ := json.Marshal(reqBody)
  reader := bytes.NewReader(reqBytes)
  client := &http.Client{}
  req, err := http.NewRequest("PUT", reqUrl, reader)
  if err != nil {
    log.Fatal(err.Error())
    return
  }
  req.Header.Add("Content-Type", "application/json")
  req.Header.Add("Authorization", geneDeviceSign())
  resp, err := client.Do(req)
  if err != nil {
    fmt.Println(err)
    return
  }
  defer resp.Body.Close()
  respStr, err := ParseResponseString(resp)
  var registerResp RegistRespStu
  err = json.NewDecoder(strings.NewReader(respStr)).Decode(&registerResp)
  if err != nil {
    log.Fatal("RegistRespStu Json To Struct Err！err>>> ", err)
  }
  log.Fatal("Response", resp)
  log.Fatal("ResponseCode", resp.StatusCode)
  log.Fatal("ResponseStr", respStr)
  if registerResp.Status == "assigning" && registerResp.OperationId != "" {
    log.Fatal("Device Regist operationId----", registerResp.OperationId)
    log.Fatal("Device Regist Status----", registerResp.Status)
    return
  }
  return
}
```

#### 4.7.2-5 接口返回

> + API接口调用成功会返回设备对应的：

| Name	       | Type	                                                                       | Description |
|-------------|-----------------------------------------------------------------------------|-------------|
| operationId | string                                                                      | 操作 ID。      |
| status	     | enum:<br/>assigned <br/>assigning <br/>disabled <br/>failed <br/>unassigned | 设备注册状态。     |

```json
{
  "operationId": "dsfdsfds23456789qazdfksnfksnfksdsf",
  "status": "assigned/assigning"
}
```

> + 由于azure这个注册服务接口是异步的，所以需要调用注册接口后，需要等待`azure iothub`注册成功，所以`status`第一次调用会返回`assigning`,再次调用才会返回`assigned`状态。

### 4.7.3 设备注册状态

#### 4.7.3-1 API详情

> + Runtime Registration - Device Registration Status Lookup
>   + URL： https://global.azure-devices-provisioning.net/{idScope}/registrations/{registrationId}?api-version=2021-06-01
>   + Service：IoT Hub Device Provisioning Service
>   + API Version：2021-06-01
>   + Method：POST
>   + RequestHeader：
>     + Content-Type:application/json
>     + Authorization:""

#### 4.7.3-2 URI 参数

| Name            | 	In	   | Required | 	Type  | 	Description                      |
|-----------------|--------|----------|--------|-----------------------------------|
| idScope         | path   | True     | string ||
| registrationId	 | path   | 	  True  | string | 注册 ID 是小写的字母数字，并且可包含连字符。          |
| api-version     | 	query | 	True    | string | 要用于请求的 API 版本。 支持的版本包括：2021-06-01 |

#### 4.7.3-3 请求正文

| Name	          | Type	          | Description              |   
|----------------|----------------|--------------------------|
| payload	       | object         | 自定义分配有效负载。               |
| registrationId | string         | 注册 ID 是小写的字母数字，并且可包含连字符。 |
| tpm	           | TpmAttestation | Tpm。                     |
#### 4.7.3-4 代码示例

```go
package main

import (
	"bytes"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"time"
)

type DevProvisionStu struct {
	RegistrationId string `json:"registrationId"`
}

type DeviceRegStatusRespStu struct {
	RegistrationId         string `json:"registrationId"`
	CreatedDateTimeUtc     string `json:"createdDateTimeUtc"`
	AssignedHub            string `json:"assignedHub"`
	DeviceId               string `json:"deviceId"`
	Status                 string `json:"status"`
	SubStatus              string `json:"substatus"`
	LastUpdatedDateTimeUtc string `json:"lastUpdatedDateTimeUtc"`
	Etag                   string `json:"etag"`
}

func Base64Decode(src string) []byte {
	dst, err := base64.StdEncoding.DecodeString(src)
	if err != nil {
		return nil
	}
	return dst
}

func geneDeviceSign() string {
	primaryKey := "" // 从iothub获取
	policyName := "registration"
	idscope := "0cn000346C6"
	registrationid := "20210623device01"
	uri := fmt.Sprintf("%s/registrations/%s", idscope, registrationid)
	expires := time.Now().Unix() + 3600

	signstr := fmt.Sprintf("%s\n%d", url.QueryEscape(uri), expires)
	signkey := Base64Decode(primaryKey)

	h := hmac.New(sha256.New, signkey)
	h.Write([]byte(signstr))
	token := base64.StdEncoding.EncodeToString(h.Sum(nil))

	params := url.Values{}
	params.Add("sr", uri)
	params.Add("sig", token)
	params.Add("se", strconv.FormatInt(expires, 10))
	params.Add("skn", policyName)
	log.Fatalf("Authorization:----", fmt.Sprintf("SharedAccessSignature %s", params.Encode()))
	return fmt.Sprintf("SharedAccessSignature %s", params.Encode())
}

func ParseResponseString(response *http.Response) (string, error) {
	//var result map[string]interface{}
	body, err := ioutil.ReadAll(response.Body) // response.Body 是一个数据流
	return string(body), err                   // 将 io数据流转换为string类型返回！
}

func main() {
	log.Fatal("GetRegInfoFromIot()----从IotHub获取设备注册信息")
	baseUrl := fmt.Sprintf("https://%s", "global.azure-devices-provisioning.cn")
	registrationId := "20220103device01"
	idScope := "0cn000346C6"
	regBaseUrl := "%s/%s/registrations/%s?api-version=2021-06-01"
	reqUrl := fmt.Sprintf(regBaseUrl, baseUrl, idScope, registrationId)
	log.Fatal("设备配置reqUrl:----", reqUrl)
	log.Fatal("设备信息, Reg请求Url", registrationId, reqUrl)
	var reqBody DevProvisionStu
	reqBody.RegistrationId = registrationId
	reqBytes, _ := json.Marshal(reqBody)

	reader := bytes.NewReader(reqBytes)
	client := &http.Client{}
	req, err := http.NewRequest("POST", reqUrl, reader)
	if err != nil {
		log.Fatal(err.Error())
		return
	}
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", geneDeviceSign())
	resp, err := client.Do(req)
	if err != nil {
		fmt.Println(err)
		return
	}
	defer resp.Body.Close()

	respStr, err := ParseResponseString(resp)
	var deviceRegStatusRespData DeviceRegStatusRespStu
	err = json.NewDecoder(strings.NewReader(respStr)).Decode(&deviceRegStatusRespData)
	if err != nil {
		log.Fatal("RegistRespStu Json To Struct Err！err>>> ", err)
	}
	log.Fatal("Response", resp)
	log.Fatal("ResponseCode", resp.StatusCode)
	log.Fatal("ResponseStr", respStr)
	if (deviceRegStatusRespData.Status == "assigned" || deviceRegStatusRespData.Status == "assigning") && deviceRegStatusRespData.RegistrationId == macConfData.Mac && deviceRegStatusRespData.AssignedHub != "" {
		log.Fatal("Device RegistInfo assignedHub----", deviceRegStatusRespData.AssignedHub)
		log.Fatal("Device RegistInfo registrationId----", deviceRegStatusRespData.RegistrationId)
		log.Fatal("Device RegistInfo Status----", deviceRegStatusRespData.Status)
		log.Fatal("Device RegistInfo deviceId----", deviceRegStatusRespData.DeviceId)
		log.Fatal("Device RegistInfo createdDateTimeUtc----", deviceRegStatusRespData.CreatedDateTimeUtc)
		return
	}
	return
}
```

