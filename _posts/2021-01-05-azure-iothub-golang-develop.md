---
layout: mypost
title: Azure IotHub Golang开发指北
categories: [Cloud, Golang, Azure]
---

# 1-Azure IotHub 开发配置

## 1.1 在Azure Portal上创建Azure IotHub

## 1.2 在Iot中心为存储账户和服务总线队列配置终结点和消息路由

> + 进入`iothub`配置界面，选择左侧的消息路由，点击新增(说直白点就是，设备上报的数据直接存储在service bus中)
> + 设置名称、终结点、消息来源默认、剩下选项默认
    >   + a.新增一个终结点-service bus (queen/topic) endpoint类型
          >     + 选择不同的endpoint类型，将会把数据持久化到不同的节点里面
>     + 消息终结点有`Event hubs`/`service bus queue`/`service bus topic`/`Storage`四种类型,这种我们使用`service bus topic`
>     + 这里需要区分下 `queen`和`topic`，`queen`是一个队列，`topic`是一个主题
>     + 队列为一个或多个竞争使用方提供先入先出 (`FIFO`) 消息传递方式。 也就是说，接收方通常会按照消息添加到队列中的顺序来接收并处理消息。 并且每条消息仅由一个消息使用方接收并处理。 使用队列的主要优点是实现应用程序组件的临时分离。 换句话说，创建方（发送方）和使用方（接收方）不必同时发送和接收消息。 这是因为消息已持久存储在队列中。 此外，创建方不必等待使用方的答复即可继续处理并发送更多消息。
>     + 队列允许单个使用方处理消息。 与队列不同，主题和订阅以“发布和订阅”模式提供一对多的通信形式。 这对于扩展到大量接收方而言十分有用。 每个发布的消息均可用于向该主题注册的每个订阅。 发布方将消息发送到主题，一个或多个订阅服务器将接收该消息的副本，具体取决于对这些订阅设置的筛选规则。 此订阅可以使用其他筛选器来限制其想要接收的消息。 发布方将消息发送到主题的方式与将消息发送到队列的方式相同。 但使用方不会直接从主题接收消息。 相反，使用方从该主题的订阅接收消息。 主题订阅类似于接收发送至该主题的消息副本的虚拟队列。 使用方从订阅接收消息的方式与从队列接收消息的方式相同。
>   + b.需要设置endpoint名称，添加与此IoT中心共享订阅的已存在的service bus (queen/topic)，若没有，就需要新建service bus和对应的topic，其他内容默认。
> + 点击创建

## 1.3 在设备中配置终结点和消息路由

# 2.Azure IotHub Portal 配置

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
> + 设备上报(D2C)
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

> + DPS 具有许多功能，非常适合用于预配设备。
    >   + 对基于 X.509 和 TPM 的标识 的安全证明支持。
    >   + 注册列表，其中包含可能在某一时刻注册的设备/设备组的完整记录 。 注册列表包含有关设备注册后所需的设备配置信息，并可随时更新。
>   + 多个分配策略，用于根据自己的需要控制 DPS 向 IoT 中心分配设备的方式：通过注册列表控制最小延迟、平均加权分布（默认值）和静态配置。 延迟是使用与流量管理器相同的方法确定的。
>   + 监视和诊断日志记录，用于确保一切都正常工作。
>   + 多中心支持，允许 DPS 将设备分配给多个 IoT 中心。 DPS 可以跨多个 Azure 订阅来与中心通信。
>   + 跨区域支持使 DPS 能够将设备分配到其他区域的 IoT 中心。
>   + 静态数据加密允许使用 256 位 AES 加密（可用的最强大的分组加密法之一，并且符合 FIPS 140-2）透明地加密和解密 DPS 中的数据。

可以通过查看 [DPS 术语](https://docs.microsoft.com/zh-cn/azure/iot-dps/concepts-service)主题以及同一部分的其他概念性主题来详细了解设备预配中涉及的概念和功能。

## 4.4 跨平台支持

> + 与所有 Azure IoT 服务一样，DPS 可以在各种操作系统上跨平台运行。 Azure 采用各种语言提供了开放源 SDK，以便于连接设备并管理服务。 DPS 支持使用以下协议来连接设备：
    >   + HTTPS
>   + AMQP
>   + 基于 Web 套接字的 AMQP
>   + MQTT
>   + 基于 Web 套接字的 MQTT

> DPS 仅支持使用 HTTPS 连接来执行服务操作。

## 4.5 配额和限制

> + 每个 Azure 订阅附带默认的配额限制，这些限制可能影响 IoT 解决方案的范围。 每个订阅的当前限制是每订阅 10 个设备预配服务。

### 4.5.1 适用于 Azure IoT 中心设备预配服务资源的限制。

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

### 4.5.2 设备预配服务具有以下速率限制。

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

| Name	                               | Required	            | Type	                                                                                       | Description                                                                                                                                                                                                                                                                                    |
|-------------------------------------|----------------------|---------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| attestation	                        | True                 | AttestationMechanism                                                                        | 设备使用的证明方法。                                                                                                                                                                                                                                                                                     |
| registrationId	                     | True                 | string                                                                                      | 注册 ID 是小写的字母数字，并且可包含连字符。                                                                                                                                                                                                                                                                       |
| allocationPolicy	                   | 	                    | enum: <br/>hashed <br/>geoLatency <br/>static <br/>custom                                   | 此资源的分配策略。 此策略覆盖此单个注册组或注册组的租户级别分配策略。 可能的值包括 "哈希"：链接的 IoT 中心可能会将设备预配到设备 "geoLatency"：将设备预配到具有最低延迟的 IoT 中心。如果多个链接的 IoT 中心提供相同的最低延迟，则预配服务会在这些中心中对设备进行哈希处理： "静态"：注册列表中所需 IoT 中心的规范优先于服务级别分配策略，"自定义"：根据自己的自定义逻辑将设备预配到 IoT 中心。 预配服务将有关设备的信息传递给逻辑，逻辑返回所需的 IoT 中心以及所需的初始配置。 建议使用 Azure Functions 来托管逻辑。 |
| capabilities	                       | 	                    | DeviceCapabilities                                                                          | 设备的功能。                                                                                                                                                                                                                                                                                         |
| customAllocationDefinition          | 		                   | CustomAllocationDefinition                                                                  | 这会告知 DPS 使用自定义分配时要调用的 webhook。                                                                                                                                                                                                                                                                 |
| deviceId	                           | 	                    | string                                                                                      | 所需的 IoT 中心设备 ID (可选) 。                                                                                                                                                                                                                                                                         |
| etag	                               | 	                    | string                                                                                      | 与资源关联的实体标记。                                                                                                                                                                                                                                                                                    |
| initialTwin		                       |                      | InitialTwin                                                                                 | 初始设备克隆。                                                                                                                                                                                                                                                                                        |
| iotHubHostName		                    |                      | string                                                                                      | Iot 中心主机名。                                                                                                                                                                                                                                                                                     |
| iotHubs		                           |                      | string[]                                                                                    | IoT 中心主机名，可以将此资源中 () 的设备分配到该列表。 必须是 IoT 中心的租户级别列表的子集。                                                                                                                                                                                                                                          |
| optionalDeviceInformation		         |                      | TwinCollection                                                                              | 可选的设备信息。                                                                                                                                                                                                                                                                                       |
| provisioningStatus		                |                      | enum: <br/>enabled <br/>disabled                                                            | 预配状态。                                                                                                                                                                                                                                                                                          |
| reprovisionPolicy		                 |                      | ReprovisionPolicy                                                                           | 将设备重新预配到 IoT 中心时的行为。                                                                                                                                                                                                                                                                           |

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
	DevProvisonEndPoint := "xxxx.azure-devices-provisioning.cn"
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
  regBaseUrl := "xxxx.azure-devices.cn"
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
> + URL： https://global.azure-devices-provisioning.net/{idScope}/registrations/{registrationId}?api-version=2021-06-01
    >    + Service：IoT Hub Device Provisioning Service
>    + API Version：2021-06-01
>    + Method：POST
>    + RequestHeader：
       >      + Content-Type:application/json
>      + Authorization:""

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
	registrationId := "myDevice"
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

#### 4.7.3-5 接口返回

> + API接口调用成功会返回设备对应的：

| Name	                                                          | Type	                                                                                                                                                    | Description                      |
|----------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------|
| assignedHub                                                    | string                                                                                                                                                   | 已分配Azure IoT中心。                  |
| createdDateTimeUtc                                             | string                                                                                                                                                   | 注册创建日期时间 (UTC) 。                 |
| deviceId                                                       | string                                                                                                                                                   | 设备 ID。                           |
| errorCode                                                      | integer                                                                                                                                                  | 错误代码。                            |
| errorMessage                                                   | string                                                                                                                                                   | 错误消息。                            |
| etag                                                           | string                                                                                                                                                   | 与资源关联的实体标记。                      |
| lastUpdatedDateTimeUtc                                         | string                                                                                                                                                   | 上次更新的日期时间 (UTC) 。                |
| payload                                                        | object                                                                                                                                                   | 从 Webhook 返回到设备的自定义分配有效负载。       |
| registrationId                                                 | string                                                                                                                                                   | 注册 ID 是小写的字母数字，并且可包含连字符。         |
| status	                                                        | enum: <br/>assigned <br/>assigning <br/>disabled <br/>failed <br/>unassigned                                                                             | 注册状态。                            |
| substatus                                                      | enum: <br/>deviceDataMigrated <br/>deviceDataReset <br/>initialAssignment                                                                                | reprovisionedToInitialAssignment |"已分配"设备的子状态。 可能的值包括 -"initialAssignment"：设备已首次分配到 IoT 中心，"deviceDataMigrated"：设备已分配到其他 IoT 中心，其设备数据从以前分配的 IoT 中心迁移。 设备数据已从以前分配的 IoT 中心"deviceDataReset"中删除：设备已分配到其他 IoT 中心，其设备数据已从注册中存储的初始状态填充。 设备数据已从以前分配的 IoT 中心"reprovisionedToInitialAssignment"中删除：设备已重新预配到以前分配的 IoT 中心。|
| symmetricKey                                                   | SymmetricKeyRegistrationResult                                                                                                                           | 使用 SymmetricKey 证明时返回的注册结果。      |
| tpm                                                            | TpmRegistrationResult                                                                                                                                    | 使用 TPM 证明时返回的注册结果。               |
| x509                                                           | X509RegistrationResult                                                                                                                                   | 使用 X509 证明时返回的注册结果。              |

```json
{
  "assignedHub": "",
  "createdDateTimeUtc": "",
  "deviceId": "",
  "errorCode": "",
  "errorMessage": "",
  "etag": "",
  "lastUpdatedDateTimeUtc": "",
  "payload": "",
  "registrationId": "",
  "status": "assigned",
  "substatus": ""
}
```

> + 当返回的数据内的`status`为`assigned`,就代表当前设备已注册成功,同时通过`assignedHub`参数的值也能看到对应的`iothub`了。

# 5 设备上报数据到azure iot hub--D2C(设备到云的消息)

## 5.1 将信息从设备应用发送到解决方案后端时，IoT 中心会公开三个选项：

> + 设备到云消息，用于时序遥测和警报。
> + 设备孪生的报告属性，用于报告设备状态信息，例如可用功能、条件或长时间运行的工作流的状态。 例如，配置和软件更新。
> + 文件上传，用于由间歇性连接的设备上传的或为了节省带宽而压缩的媒体文件和大型遥测批文件。

## 5.2 设备到云通信选项的详细比较。

| 因子	    | 设备到云的消息                                | 	设备克隆的报告属性	                                               | 文件上传                        |
|--------|----------------------------------------|-----------------------------------------------------------|-----------------------------|
| 方案	    | 遥测时序和警报。 例如，每隔 5 分钟发送 256-KB 的传感器数据批。	 | 可用功能和条件。 例如，当前设备连接模式，诸如手机网络或 WiFi。 同步长时间运行的工作流，如配置和软件更新。	 | 视频或其他大型媒体文件。 大型（通常为压缩的）遥测批。 |
| 存储和检索	 | 通过 IoT 中心临时进行存储，最多存储 7 天。仅顺序读取。	       | 通过 IoT 中心存储在设备孪生中。 可使用 IoT 中心查询语言进行检索。	                   | 存储在用户提供的 Azure 存储帐户中。       |
| 大小	    | 消息大小最大为 256-KB。	                       | 最大报告属性大小为 32 KB。	                                         | Azure Blob 存储支持的最大文件大小。     |
| 频率	    | 高。 有关详细信息，请参阅 IoT 中心限制。                | 	中。 有关详细信息，请参阅 IoT 中心限制。	                                 | 低。 有关详细信息，请参阅 IoT 中心限制。     |
| 协议	    | 在所有协议上可用。	                             | 使用 MQTT 或 AMQP 时可用。	                                      | 在使用任何协议时可用，但设备上必须具备 HTTPS。  |应用程序可能需要同时将信息作为遥测时序或警报发送，并且使其在设备孪生中可用。 在这种情况下，可以选择以下选项之一：|

## 5.3 应用发送一条设备到云消息并报告属性更改。

> + 解决方案后端在收到消息时可将信息存储在设备孪生的标记中。
> + 由于设备到云消息允许的吞吐量远高于设备孪生更新，因此有时需要避免为每条设备到云消息更新设备孪生。
> + 由于设备到云消息允许的吞吐量远高于设备孪生更新，因此有时需要避免为每条设备到云消息更新设备孪生。

## 5.4 设备发送消息到云

### 5.4.1 消息路由

消息路由使你能够以自动、可缩放以及可靠的方式将消息从设备发送到云服务。 消息路由可用于：

> + 发送设备遥测消息以及事件（即设备生命周期事件、设备孪生更改事件、数字孪生体更改事件和设备连接状态事件）到内置终结点和自定义终结点。 了解有关路由终结点。 若要详细了解从 IoT 即插即用设备发送的事件，请参阅了解 IoT 即插即用数字孪生体。

> + 在将数据路由到各个终结点之前对数据进行筛选，筛选方法是通过应用丰富的查询。 消息路由允许你查询消息属性和消息正文以及设备孪生标记和设备孪生属性。 深入了解如何使用消息路由中的查询。

### 5.4.2 请求参数

| 请求方式 | 请求地址                                     | 参数                                                                                     | 说明                                                                                                                           |
|------|------------------------------------------|----------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| MQTT | /devices/{deviceId}/messages/events      | 若要在 IoT 中心路由查询中使用消息正文，必须为消息提供有效的 JSON 对象，并将消息的内容类型属性设置为 application/json;charset=utf-8 | 设备到云的消息最大可为 256 KB，而且可分成多个批以优化发送。 批最大可为 256 KB                                                                               |
| AMQP | /devices/{deviceId}/messages/events      | 若要在 IoT 中心路由查询中使用消息正文，必须为消息提供有效的 JSON 对象，并将消息的内容类型属性设置为 application/json;charset=utf-8 | 设备到云的消息最大可为 256 KB，而且可分成多个批以优化发送。 批最大可为 256 KB                                                                               |
| HTTP | POST /devices/{deviceId}/messages/events | 若要在 IoT 中心路由查询中使用消息正文，必须为消息提供有效的 JSON 对象，并将消息的内容类型属性设置为 application/json;charset=utf-8 | 使用 HTTPS 协议发送设备到云的消息或发送云到设备的消息时，属性名称和值只能包含 ASCII 字母数字字符加上 {'!', '#', '$', '%, '&', ''', '*', '+', '-', '.', '^', '_', '`', ' |', '~'}|

### 5.4.2 消息正文示例

```json
{
    "timestamp": "2022-02-08T20:10:46Z",
    "tag_name": "spindle_speed",
    "tag_value": 100
}
```

### 5.4.3 代码示例

```go
package main

import (
	"context"
	"github.com/tomtao626/iothub/iotdevice"
	iotmqtt "github.com/tomtao626/iothub/iotdevice/transport/mqtt"  // go get -u github.com/tomtao626/iothub
	"log"
)

func main() {
	dc, err := iotdevice.NewFromConnectionString(
		iotmqtt.New(), "HostName=xxxx.azure-devices.net;DeviceId=myDevice;SharedAccessKey=9l9Cxfdsf5qOQCi8EsfsfUllaeXqcYVExi6+moh+wq/M0aTrIzI=",
	)
	if err != nil {
		log.Fatal(err)
	}
	// connect to the iothub
	if err = dc.Connect(context.Background()); err != nil {
		log.Fatal(err)
	}

	// send a device-to-cloud message
	if err = dc.SendEvent(context.Background(), []byte("kubeshare")); err != nil {
		log.Fatal(err)
	}
}
```

## 5.4.4 从 IoT 中心路由查询消息正文

> + 从内置终结点进行读取(即插即用-遥测数据)
> + 从 Blob 存储进行读取
    >   + 1.创建资源组
>   + 2.创建存储帐户
>   + 3.创建消息终结点
>   + 4.启用事件网格资源提供程序
>   + 5.订阅存储帐户
>   + 6.触发 Blob 存储中的事件
>   + 7.清理资源
> + 从事件中心进行读取
> + 从服务总线主题进行读取(<a href="#sb7-1">服务总线主题</a>)
> + 从服务总线队列进行读取(<a href="#sb7-2">服务总线队列</a>)

## 5.5 设备上传文件

> + `IoT` 中心通过在预先配置了该中心的 `blob` 容器和 `Azure` 存储帐户的每次上传基础上，为连接设备提供共享访问签名 `(SAS) URI`，来帮助从设备上传文件。 使用 `IoT` 中心进行文件上传有三个部分：
    >   + 在 `IoT` 中心预配置 `Azure` 存储帐户和 `blob` 容器、
    >   + 从设备上传文件，
    >   + 以及（可选）就完成文件上传通知后端服务。

### 5.5.1 设备操作步骤:

> + 设备将通过 IoT 中心启动文件上传。
    >  + 它在请求中传递 blob 名称，并返回一个 SAS URI 和相关 ID。 SAS URI 包含 Azure 存储的 SAS 令牌，该令牌授予对 blob 容器中所请求的 blob 的设备读写权限。 有关详细信息，请参阅[设备：初始化文件上传](https://docs.microsoft.com/zh-cn/azure/iot-hub/iot-hub-devguide-file-upload#device-initialize-a-file-upload)。
> + 设备使用 SAS URI 安全地调用 Azure blob 存储 API，以将文件上传到 blob 容器。
    >  + 有关详细信息，请参阅[设备：使用 Azure 存储 API 上传文件](https://docs.microsoft.com/zh-cn/azure/iot-hub/iot-hub-devguide-file-upload#device-upload-file-using-azure-storage-apis)。
> + 文件上传完成后，设备会使用在启动上传时从 IoT 中心收到的相关 ID，通知 IoT 中心完成状态。
    >  + 有关详细信息，请参阅设备：[通知 IoT 中心已完成文件上传](https://docs.microsoft.com/zh-cn/azure/iot-hub/iot-hub-devguide-file-upload#device-notify-iot-hub-of-a-completed-file-upload)。

### 5.5.2 使用`SDK`上传文件

#### 5.5.2-1 设备：初始化文件上传

#### 5.5.2-2 设备调用 [Create File Upload SAS URI REST API](https://docs.microsoft.com/zh-CN/rest/api/iothub/device/create-file-upload-sas-uri) 或其中一个设备 `SDK` 中的等效 `API` 来启动文件上传。

> + 支持的协议：`HTTPS`
> + 终结点：`{iot hub}.azure-devices.net/devices/{deviceId}/files`
> + 方法：`POST`
> + HTTP：`POST https://fully-qualified-iothubname.azure-devices.net/devices/{deviceId}/files?api-version=2020-03-13`

```json
{
    "correlationId":"MjAyMTA3MzAwNjIxXzBiNjgwOGVkLWZjNzQtN...MzYzLWRlZmI4OWQxMzdmNF9teWZpbGUudHh0X3ZlcjIuMA==",
    "hostName":"contosostorageaccount.blob.core.windows.net",
    "containerName":"device-upload-container",
    "blobName":"mydevice/myfile.txt",
    "sasToken":"?sv=2018-07-28&sr=b&sig=mBLiODhpKXBs0y9RVzwk1S...l1X9qAfDuyg%3D&se=2021-07-30T06%3A11%3A10Z&sp=rw"
}
```

#### 5.5.2-3 参数描述

> + IoT 中心使用相关 ID 和 SAS URI 的元素进行响应，设备可以使用这些元素向 Azure 存储进行身份验证。 此响应受目标 IoT 中心的限制和每设备上传限制的制约。
> + 参数描述

| 属性            | 	描述                                                                                               |
|---------------|---------------------------------------------------------------------------------------------------|
| correlationId | 设备在将文件上传完成通知发送到 IoT 中心时使用的标识符。                                                                    |
| hostName	     | IoT 中心上配置的存储帐户的 Azure 存储帐户主机名                                                                     |
| containerName | 在 IoT 中心配置的 Blob 容器的名称。                                                                           |
| blobName	     | blob 将存储在容器中的位置。 该名称采用以下格式：{device ID of the device making the request}/{blobName in the request} |
| sasToken	     | 一个 SAS 令牌，用于通过 Azure 存储授予对 blob 的读写访问权限。 令牌由 IoT 中心生成并签名。                                         |

#### 5.5.2-4 收到响应时，设备会执行以下操作：

> + 保存相关 `ID`，以便在完成上传时将相关 `ID` 包含在发送给 `IoT` 中心的文件上传完成通知中。
> + 使用其他属性为 `Blob` 构造 `SAS URI`，用于向 `Azure` 存储进行身份验证。`SAS URI` 包含所请求 `blob` 的资源 `URI` 和 `SAS` 令牌。 它采用以下形式：`https://{hostName}/{containerName}/{blobName}{sasToken}`（响应中的 `sasToken` 属性包含前导“?”字符。）不包括大括号。
> + 例如，对于上述示例中返回的值，`SAS URI` 为 `https://contosostorageaccount.blob.core.windows.net/device-upload-container/mydevice/myfile.txt?sv=2018-03-28&sr=b&sig=mBLiODhpKXBs0y9RVzwk1S...l1X9qAfDuyg%3D&se=2021-07-30T06%3A11%3A10Z&sp=rw`


### 5.5.3 设备：使用 `Azure` 存储 `API` 上传文件

#### 5.5.3-1 设备使用 [Azure Blob 存储 REST API](https://docs.microsoft.com/zh-CN/rest/api/storageservices/blob-service-rest-api) 或等效的 `Azure` 存储 `SDK API` 将文件上传到 `Azure` 存储中的 `Blob`

> + 支持的协议：`HTTPS`
> + HTTP demo示例:
> + 以下示例演示用于创建或更新小型块 `blob` 的 `Put Blob` 请求。 请注意，用于此请求的 `URI` 是上一部分中 `IoT` 中心返回的 `SAS URI`。 `x-ms-blob-type` 标头指示此请求适用于块 `blob`。 如果请求成功，`Azure` 存储将返回 `201 Created`。

```shell
PUT https://contosostorageaccount.blob.core.windows.net/device-upload-container/mydevice/myfile.txt?sv=2018-07-28&sr=b&sig=mBLiODhpKXBs0y9RVzwk1S...l1X9qAfDuyg%3D&se=2021-07-30T06%3A11%3A10Z&sp=rw HTTP/1.1
Content-Length: 11
Content-Type: text/plain; charset=UTF-8
Host: contosostorageaccount.blob.core.windows.net
x-ms-blob-type: BlockBlob
hello world
```

### 5.5.4 设备：通知 `IoT` 中心已完成文件上传

> + 完成文件上传时，设备会调用 [Update File Upload Status REST API(此方法用于通知 IoT 中心已完成的文件上传)](https://docs.microsoft.com/zh-CN/rest/api/iothub/device/update-file-upload-status) 或其中一个设备 `SDK` 中的等效 `API`。 无论上传是成功还是失败，设备都应向 IoT 中心更新文件上传状态。
> + 支持的协议：`HTTPS`
> + 终结点：`{iot hub}.azure-devices.net/devices/{deviceId}/files/notifications`
> + 方法：`POST`
> + HTTP: `POST https://fully-qualified-iothubname.azure-devices.net/devices/{deviceId}/files/notifications?api-version=2020-03-13`

#### 5.5.4-1 请求示例

```json
{
    "correlationId": "MjAyMTA3MzAwNjIxXzBiNjgwOGVkLWZjNzQtN...MzYzLWRlZmI4OWQxMzdmNF9teWZpbGUudHh0X3ZlcjIuMA==",
    "isSuccess": true,
    "statusCode": 200,
    "statusDescription": "File uploaded successfully"
}
```

#### 5.5.4-2 参数描述

| 属性                 | 	描述                                    |
|--------------------|----------------------------------------|
| correlationId      | 	初始 SAS URI 请求中接收的相关 ID。               |
| isSuccess	         | 一个布尔值，指示文件上传是否成功。                      |
| statusCode	        | 一个整数，表示文件上传的状态代码。 通常为三位数；例如 200 或 201。 |
| statusDescription	 | 文件上传状态说明。                              |

> + 当它从设备收到文件上传完成通知时，IoT 中心将执行以下操作：
    >   + 如果配置了文件上传通知，则触发到后端服务的文件上传通知。
    >   + 释放与文件上传关联的资源。 如果未收到通知，IoT 中心将保留资源，直到与上传关联的 SAS URI 生存时间 (TTL) 过期。

### 5.5.5 服务：文件上传通知

> + 如果在 `IoT` 中心启用了文件上传通知，则当从设备接收到文件上传完成的通知时，它会为后端服务生成通知消息。 `IoT` 中心通过面向服务的终结点传送这些文件上传通知。
> + 文件上传通知的接收语义与云到设备消息的接收语义相同，并且具有相同的[消息生命周期](https://docs.microsoft.com/zh-cn/azure/iot-hub/iot-hub-devguide-messages-c2d#the-cloud-to-device-message-life-cycle)。 服务 `SDK` 公开 `API` 来处理文件上传通知。
> + 支持的协议 `AMQP`、`AMQP-WS`
> + 终结点：`{iot hub}.azure-devices.net/messages/servicebound/fileuploadnotifications`
> + 方法 `GET`
> + 从文件上传通知终结点检索到的每条消息都是 JSON 记录：

#### 5.5.5-1 请求示例

```json
{
"deviceId":"mydevice",
"blobUri":"https://contosostorageaccount.blob.core.windows.net/device-upload-container/mydevice/myfile.txt",
"blobName":"mydevice/myfile.txt",
"lastUpdatedTime":"2021-07-31T00:26:50+00:00",
"blobSizeInBytes":11,
"enqueuedTimeUtc":"2021-07-31T00:26:51.5134008Z"
}
```

#### 5.5.5-2 参数描述

| 属性	              | 说明                                                               |
|------------------|------------------------------------------------------------------|
| enqueuedTimeUtc	 | 指示通知创建时间的时间戳。                                                    |
| deviceId	        | 上传文件的设备的设备 ID。                                                   |
| blobUri	         | 已上传文件的 URI。                                                      |
| blobName	        | 已上传文件的名称。 该名称采用以下格式：{device ID of the device}/{name of the blob} |
| lastUpdatedTime	 | 指示文件更新时间的时间戳。                                                    |
| blobSizeInBytes	 | 一个整数，表示上传文件的大小（以字节为单位）。                                          |

> + 服务可以使用通知来管理上传。 例如，它们可以触发自己对 blob 数据的处理，使用其他 Azure 服务触发 blob 数据处理，或记录文件上传通知以便以后查看。

# 6 Azure Iot Hub发送数据到本地--C2D(云到设备的消息)

## 6.1 IoT 中心提供三个选项，允许设备应用向后端应用公开功能：

>  + `直接方法`，适用于需要立即确认结果的通信。 直接方法通常用于以交互方式控制设备，例如打开风扇。
>  + `孪生的所需属性`，适用于旨在将设备置于某个所需状态的长时间运行命令。 例如，将遥测发送间隔设置为 30 分钟。
>  + `云到设备消息`，适用于向设备应用提供单向通知。

## 6.2 云到设备的通信选项的详细对比

| 类别	 | `直接方法`	                                     | `孪生的所需属性`	                                          | `云到设备的消息`                    |
|-----|---------------------------------------------|-----------------------------------------------------|------------------------------|
| 方案	 | 需要立即确认的命令，例如打开风扇。	                          | 旨在将设备置于某个所需状态的长时间运行命令。 例如，将遥测发送间隔设置为 30 分钟。         | 	提供给设备应用的单向通知。               |
| 数据流 | 	双向。 设备应用可以立即响应方法。 解决方案后端根据上下文接收请求结果。	      | 单向。 设备应用接收更改了属性的通知。	                                | 单向。 设备应用接收消息                 |
| 持续性 | 	不联系已断开连接的设备。 通知解决方案后端：设备未连接。	              | 设备孪生会保留属性值。 设备会在下次重新连接时读取属性值。 属性值可通过 IoT 中心查询语言检索。	 | IoT 中心可保留消息长达 48 小时。         |
| 目标	 | 使用 deviceId 与单个设备通信，或使用作业与多个设备通信。	          | 使用 deviceId 与单个设备通信，或使用作业与多个设备通信。	                  | 通过 deviceId与单个设备通信。          |
| 大小	 | 请求的最大直接方法有效负载大小为 128 KB，响应的相应负载大小为 128 KB。	 | 所需属性大小最大为 32 KB。	                                   | 最多 64 KB 消息。                 |
| 频率	 | 高。 有关详细信息，请参阅 IoT 中心限制。	                    | 中。 有关详细信息，请参阅 IoT 中心限制。	                            | 低。 有关详细信息，请参阅 IoT 中心限制。      |
| 协议	 | 使用 MQTT 或 AMQP 时可用。	                        | 使用 MQTT 或 AMQP 时可用。	                                | 在所有协议上可用。 使用 HTTPS 时，设备必须轮询。 |

### 6.2.1 备注

>  + 可以通过面向服务的终结点 `/messages/devicebound` 发送从云到设备的消息。 随后设备可以通过特定于设备的终结点 `/devices/{deviceId}/messages/devicebound` 接收这些消息。
>  + 要将每个从云到设备的消息都设为以单个设备为目标，请通过 `IoT` 中心将 `to` 属性设置为 `/devices/{deviceId}/messages/devicebound`。
>  + 每个设备队列最多可以保留 50 条云到设备的消息。 尝试将更多消息传送到同一设备会导致错误。

### 6.2.2 消息生命周期

>  + ![](https://docs.microsoft.com/zh-cn/azure/iot-hub/media/iot-hub-devguide-messages-c2d/lifecycle.png)
>  + IoT 中心服务向设备发送消息时，该服务会将消息状态设置为“`排队`”。
>  + 当设备想要接收某条消息时，`IoT` 中心会通过将状态设置为“`不可见`”来锁定该消息。 这种状态使得设备上的其他线程可以开始接收其他消息。
>  + 当设备线程完成消息的处理后，会通过完成消息来通知 IoT 中心。 随后 IoT 中心会将状态设置为“`已完成`”
>  + 线程可能无法处理消息，且不通知 IoT 中心。 在此情况下，在可见性超时（或锁定超时）之后，消息从不可见状态自动转换回已排队状态。 此超时的值为一分钟，无法更改。
>  + 消息可以在“`已排队`”与“`不可见`”状态之间转换的次数，以 IoT 中心上“`最大传送计数`”属性中指定的次数为上限。
>  + 在该转换次数之后，`IoT` 中心会将消息的状态设置为“`死信`”。 同样，IoT 中心也会在消息的到期时间之后，将消息的状态设置为“`死信`”。 有关详细信息，请参阅生存时间。
>  + 设备支持拒绝消息，这会使 `IoT` 中心将此消息设置为“`死信`”状态。 通过消息队列遥测传输 `(MQTT)` 协议进行连接的设备无法拒绝云到设备的消息。
>  + 设备支持放弃消息，这会使 `IoT` 中心将消息放回队列，并将状态设置为“`已排队`”。 通过 `MQTT` 协议连接的设备无法放弃云到设备的消息。
>  + 在设备将任务说明保留到本地存储后完成该云到设备的消息。 在作业进度的不同阶段，可以使用一条或多条设备到云的消息通知解决方案后端。

### 6.2.3 消息到期时间

>  + 每条云到设备的消息都有过期时间。 可通过以下任一方式设置此时间：
>  + 服务中的 `ExpiryTimeUtc` 属性
>  + 使用了指定为 `IoT` 中心属性的默认生存时间的 `IoT` 中心。

> 利用消息到期时间并避免将消息发送到已断开连接的设备的常见方法是设置较短的生存时间值。 此方法可达到与维护设备连接状态一样的效果，而且更加有效。 请求消息确认时，IoT 中心将通知你哪些设备：
> + 可以接收消息。
> + 不处于联机状态，或出现故障

### 6.2.4 消息反馈

>  + 发送云到设备的消息时，服务可以请求传送每条消息的反馈（关于该消息的最终状态）。 为此，可将要发送的设备到云消息中的 iothub-ack 应用程序属性设置为以下四个值之一：
>  + 如果 Ack 值为 full，且未收到反馈消息，则意味着反馈消息已过期。 该服务无法了解原始消息的经历。 实际上，服务应该确保它可以在反馈过期之前对其进行处理。 最长过期时间是两天，因此当发生故障时，有时间让服务再次运行。

| Ack属性值 | 	行为                                |
|--------|------------------------------------|
| 无	     | IoT 中心不生成反馈消息（默认行为）。               |
| 积极     | 	如果云到设备的消息达到“已完成”状态，IoT 中心将生成反馈消息。 |
| 消极     | 	云到设备的消息达到“死信”状态时，IoT 中心生成反馈消息。    |
| full   | 	IoT 中心在任一情况下都会生成反馈消息。             |

> 当批达到 64 条消息时，或者在最后一次发送消息 15 秒后（以先满足的条件为准），系统会发送反馈。 服务必须指定 MessageId ，云到设备的消息才能将其反馈与原始消息相关联。
> 正文是记录的 JSON 序列化数组，每条记录具有以下属性

| 属性	                 | 说明                                                                                               |
|---------------------|--------------------------------------------------------------------------------------------------|
| enqueuedTimeUtc	    | 一个时间戳，指示消息的结果（例如，中心已收到反馈消息，或原始消息已过期）                                                             |
| originalMessageId	  | 与此反馈信息相关的从云到设备的消息的 MessageId                                                                     |
| statusCode	         | 必需的字符串，在 IoT 中心生成的反馈消息中使用： <br/>Success <br/>已过期 <br/>DeliveryCountExceeded <br/>已拒绝 <br/>Purged |
| description	        | StatusCode 的字符串值                                                                                 |
| deviceId	           | 与此反馈信息相关的从云到设备的消息的目标设备的 DeviceId                                                                 |
| deviceGenerationId	 | 与此反馈信息相关的从云到设备的消息的目标设备的 DeviceGenerationId                                                       |

### 6.2.5 消息Json示例

```json
[
  {
    "originalMessageId": "0987654321",
    "enqueuedTimeUtc": "2015-07-28T16:24:48.789Z",
    "statusCode": "Success",
    "description": "Success",
    "deviceId": "123",
    "deviceGenerationId": "abcdefghijklmnopqrstuvwxyz"
  },
  {}
]
```

### 6.2.6 所删除设备的待处理反馈

>  + 删除设备时，也会删除任何待处理的反馈。 设备反馈是成批发送的。 如果在设备确认收到消息和准备下一个反馈批次之间的窄窗口（通常少于 1 秒）内删除设备，则不会发生反馈。
>  + 可以通过等待一段时间让待处理的反馈在删除设备之前到达来解决此问题。 删除设备后，应认为相关消息反馈丢失。

### 6.2.7 云到设备的配置选项

>  + 每个 `IoT` 中心都针对云到设备的消息传送公开以下配置选项：

| 属性	                            | 描述	               | 范围和默认值                                     |
|--------------------------------|-------------------|--------------------------------------------|
| defaultTtlAsIso8601            | 	云到设备消息的默认 TTL    | 	ISO_8601 间隔，最大为 2 天（最小为 1 分钟）；默认值：1 小时    |
| maxDeliveryCount	              | 每个设备队列的云到设备最大传送计数 | 	1 到 100；默认值：10                            |
| feedback.ttlAsIso8601	         | 服务绑定反馈消息的保留时间	    | ISO_8601 间隔，最大为 2 天（最小为 1 分钟）；默认值：1 小时     |
| feedback.maxDeliveryCount      | 	反馈队列的最大传送计数      | 	1 到 100；默认值：10                            |
| feedback.lockDurationAsIso8601 | 	反馈队列的锁定持续时间      | 	ISO_8601 间隔（5 到 300 秒，最小值为 5 秒）；默认值：60 秒。 |

> 可以通过以下方式之一来设置配置选项：
> + `Azure` 门户：在 `IoT` 中心的“`中心设置`”下，选择“`内置终结点`”，然后转到“`云到设备的消息传递`”。 （`Azure` 门户当前不支持设置 `feedback.maxDeliveryCount` 和 `feedback.lockDurationAsIso8601` 属性。）

## 6.3 云到设备的消息(C2D)-iot云端发送消息到设备

**如果要将每个从云到设备的消息都设为以单个设备为目标，请通过 IoT 中心将 to 属性设置为 /devices/{deviceId}/messages/devicebound。 每个设备队列最多可以保留 50 条云到设备的消息。 尝试将更多消息传送到同一设备会导致错误。**

### 6.3.1 请求参数

| 请求方式 | 订阅主题                    | 描述                                            |
|------|-------------------------|-----------------------------------------------|
| MQTT | `/messages/devicebound` | 通过面向服务的终结点 `/messages/devicebound` 发送从云到设备的消息 |

### 6.3.2 响应示例

```json
{
  "status": "queued",
  "messageId": "0f9f8c9f-f8b9-4b8e-b8b8-b8b8b8b8b8b8"
}
```

### 6.3.2 代码示例

```go
package main

import (
	"context"
	"fmt"
	"github.com/tomtao626/iothub/iotservice" // go get -u github.com/tomtao626/iothub
	"log"
)

func main() {
	c, err := iotservice.NewFromConnectionString("HostName=fornanjing.azure-devices.cn;SharedAccessKeyName=iothubowner;SharedAccessKey=Yv5qF3wlaD/ADqG1RPRCOAq3AfIIEjFH1ksi6gLqbD0=")
	if err != nil {
		log.Fatal(err)
	}

	// subscribe to device-to-cloud events
	log.Fatal(c.SubscribeEvents(context.Background(), func(msg *iotservice.Event) error {
		fmt.Printf("%q sends %q", msg.ConnectionDeviceID, msg.Payload)
		return nil
	}))
}
```

## 6.4 云到设备的消息(C2D)-设备接收iot云端的消息

### 6.4.1 请求参数

| 请求方式 | 订阅主题                                       | 描述                                                                |
|------|--------------------------------------------|-------------------------------------------------------------------|
| MQTT | `/devices/{deviceId}/messages/devicebound` | 设备可以通过特定于设备的终结点 `/devices/{deviceId}/messages/devicebound` 接收这些消息 |

### 6.4.2 响应示例

```json
{
    "connectionDeviceId": "myDevice",
    "payload": "Hello from myDevice"
}
```

### 6.4.2 代码示例

* **Golang 示例**

```go
package main

import (
	"context"
	"github.com/tomtao626/iothub/iotdevice"
	iotmqtt "github.com/tomtao626/iothub/iotdevice/transport/mqtt"  // go get -u github.com/tomtao626/iothub
	"log"
)

var sc *iotdevice.Client

func main() {
	var err error
	// connect_string
	cs := "HostName=xxxx.azure-devices.cn;DeviceId=myDevice;SharedAccessKey=2poBlMHZSwpF2Jfh5CjMuNoGc6OzDEXy2mycGi1ze80="
	// Establish a connection and init mqtt through connect_string parsing
	sc, err = iotdevice.NewFromConnectionString(
		iotmqtt.New(), cs)
	if err != nil {
		log.Fatal(err)
	}
	// build connect
	err = sc.Connect(context.Background())
	if err != nil {
		log.Fatal(err)
	}
	// device subscribe
	ev, err := sc.SubscribeEvents(context.Background())
	if err != nil {
		log.Fatal(err)
	}
	log.Fatal(ev.Err())
	// iterate
	for x := range ev.C() {
		log.Fatal(ev.Err())
		log.Println("req: ", x.Properties["req"])
		log.Println("data: ", x)
		log.Println("detail: ", string(x.Payload))
	}
}
```

## 6.5 设备直接方法调用(设备控制)

**直接方法调用**

> + 借助 IoT 中心，用户可以从云中对设备调用直接方法。
> + 直接方法表示与设备进行的请求-答复式交互，类似于会立即成功或失败（在用户指定的超时时间后）的 HTTP 调用。
> + 此方法用于即时操作过程不同的情况，即时操作的不同取决于设备能否响应。
> + 每个设备方法针对一个设备。 [在多个设备上计划作业](https://docs.microsoft.com/zh-cn/azure/iot-hub/iot-hub-devguide-jobs)展示了一种方法，用于对多个设备调用直接方法，并为已断开连接的设备计划方法调用。
> + 只要拥有 IoT 中心的“服务连接”权限，任何人都可以调用设备上的方法。
> + 直接方法遵循请求-响应模式，适用于需要立即确认其结果的通信。 例如对设备的交互式控制，如打开风扇。
> + 如果在使用所需属性、直接方法或云到设备消息方面有任何疑问，请参阅[云到设备通信指南](https://docs.microsoft.com/zh-cn/azure/iot-hub/iot-hub-devguide-c2d-guidance)

### 6.5.1 调用直接方法(服务端)

> + 直接方法在设备上实现，可能需要在方法有效负载中进行 0 次或 0 次以上的输入才能正确地实例化。 可以通过面向服务的 `URI ({iot hub}/twins/{device id}/methods/)` 调用直接方法。

#### 6.5.1-1 请求参数

| BaseUrl                                              | Path                                             | Desc   | Method | Params       | Body | Header                                           |
|------------------------------------------------------|--------------------------------------------------|--------|--------|--------------|------|--------------------------------------------------|
| https://fully-qualified-iothubname.azure-devices.net | /twins/{deviceId}/methods?api-version=2021-04-12 | 调用直接方法 | POST   | api-version=2021-04-12<br/>deviceId | 无    | Content-Type:application/json<br/>Authorization:"" |

#### 6.5.1-2 响应参数

```json
{
"status" : 200,
"payload" : {
  "result": {}
  }
}
```

> + 后端应用接收响应，响应由以下项构成：
> + status 和 body 均由设备提供，用于响应，其中包含设备自身的状态代码和/或描述
> + HTTP 状态代码：
    >   + 200 表示成功执行直接方法；
>   + 404 表示设备 ID 无效，或者设备在调用直接方法后 connectTimeoutInSeconds 秒内未联机（请使用伴随的错误消息来了解根本原因）；
>   + 504 表示由于设备在 responseTimeoutInSeconds 秒内未响应直接方法调用而导致网关超时。
> + 标头，包含 ETag、请求 ID、内容类型和内容编码。
> + 调用设备上的直接方法时，属性名称和值只能包含 US-ASCII 可打印字母数字，但下列组中的任一项除外：`{'$', '(', ')', '<', '>', '@', ',', ';', ':', '\', '"', '/', '[', ']', '?', '=', '{', '}', SP, HT}`
> + 直接方法是同步的，在超时期限（默认：30 秒，可设置为 5 到 300 秒）。 直接方法适用于交互式场景，即当且仅当设备处于联机状态且可接收命令时，用户希望设备做出响应。 例如，打开手机的灯。 在此类方案中，用户需要立即看到结果是成功还是失败，以便云服务可以尽快根据结果进行操作。 设备可能返回某些消息正文作为方法的结果，但系统不会要求方法一定这样做。 无法保证基于方法调用的排序或者任何并发语义。
> + 直接方法从云端只能通过 `HTTPS` 调用，从设备端可以通过 `MQTT`、`AMQP`、基于 `WebSocket` 的 `MQTT` 或 基于 `WebSockets` 的 `AMQP` 调用。
> + 方法请求和响应的有效负载为最大 128 KB 的 `JSON` 文档。

#### 6.5.1-3 代码示例

* **curl 示例**

```bash
curl -X POST \
  https://<iothubName>.azure-devices.net/twins/<deviceId>/methods?api-version=2021-04-12\
  -H 'Authorization: SharedAccessSignature sr=iothubname.azure-devices.net&sig=x&se=x&skn=iothubowner' \
  -H 'Content-Type: application/json' \
  -d '{
	"methodName":"TestMethod",
	"payload":{
        "a": 3,
        "b": 1.5,
  }
}'
```

* **Golang 示例**

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
	"strings"
	"time"
)

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
	reqUrl := "https://<iothubname>.azure-devices.net/twins/<deviceId>/methods?api-version=2021-04-12"
	reqHeader := map[string]string{
		"Authorization": "SharedAccessSignature sr=iothubname.azure-devices.net&sig=x&se=x&skn=iothubowner",
		"Content-Type":  "application/json",
	}
	reqBody := map[string]interface{}{
		"methodName": "TestMethod",
		"payload": map[string]interface{}{
			"a": 3,
			"b": 1.5,
		},
	}
	client := &http.Client{}
	req, err := http.NewRequest("POST", reqUrl, bytes.NewBuffer(json.Marshal(reqBody))).WithHeaders(reqHeader)
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", geneDeviceSign())
	if err != nil {
		panic(err)
	}
	resp, err := client.Do(req)
	if err != nil {
		panic(err)
		return
	}
	defer resp.Body.Close()

	respStr, err := ParseResponseString(resp)
	var directMethodResp struct {
		Status  string                 `json:"status"`
		Payload map[string]interface{} `json:"payload"`
	}
	err = json.NewDecoder(strings.NewReader(respStr)).Decode(&directMethodResp)
	if err != nil {
		panic(err)
	}
}
```

### 6.5.2 接收直接方法(设备端)

> + 设备通过特定于设备的 `MQTT` 主题 (`$iothub/methods/POST/{method name}/`) 或通过 AMQP 链接（`IoThub-methodname` 和 `IoThub-status` 应用程序属性）接收直接方法。

#### 6.5.2-1 MQTT调用

**方法调用**

> + 设备通过 `MQTT` 主题接收直接方法请求：`$iothub/methods/POST/{method name}/?$rid={request id}`。
    >   + 每个设备的订阅数限制为 5。 因此，建议不要单独订阅每种直接方法。 而是考虑订阅 `$iothub/methods/POST/#`，然后根据所需的方法名称筛选传递的消息。
>   + 方法请求为Qos0

**响应**

> + 设备将响应发送到 `$iothub/methods/res/{status}/?$rid={request id}`，其中：
    >   + `status` 属性是设备提供的方法执行状态。
>   + `$rid` 属性是从 `IoT` 中心接收的方法调用中的请求 ID。
>   + 正文由设备设置，可以是任何状态。

#### 6.5.2-2 AMQP调用

**方法调用**

> + 设备通过在地址 `amqps://{hostname}:5671/devices/{deviceId}/methods/deviceBound` 上创建一个接收链接以接收直接方法请求。
    >   + AMQP 消息会到达表示方法请求的接收链接。 它包含以下部分：
>   + 相关 `ID` 属性，其中包含一个应与相应的方法响应被传回的请求 ID。
> + 名为 `IoThub-methodname` 的一个应用程序属性，其中包含调用的方法名称。
> + AMQP 消息正文，其中包含作为 `JSON` 的方法有效负载。

**响应**

> + 设备会创建一个发送链接以在 `amqps://{hostname}:5671/devices/{deviceId}/methods/deviceBound` 地址上返回方法响应。 方法的响应在发送链接上返回，并已按以下内容结构化：
    >   + 相关 `ID` 属性，其中包含在方法的请求消息中传递的请求 `ID`。
> + 名为 `IoThub-status` 的一个应用程序属性，其中包含用户提供的方法状态。
> + `AMQP` 消息正文，其中包含作为 JSON 的方法响应。

#### 6.5.2-3 请求参数

```json
{
  "methodName":"TestMethod",
  "payload":{
    "a": 3,
    "b": 1.5
  }
}
```

#### 6.5.2-4 响应参数

> + 对应的`methodName`和`payload`是设备端和服务端商量定义好的
> + 当设备运行此程序时，代表设备处于在线状态，服务端对其进行直接方法调用，比如下面这个例子，将会返回如下Json格式的数据。

```json
{
  "status": 200,
  "payload": {
    "result": 4.5
  }
}
```

#### 6.5.2-5 代码示例(此处仅做MQTT示例)

* **Golang 示例**

```golang
package main

import (
  "context"
  "fmt"
  "github.com/Tomtao626/iothub/iotdevice"
  iotmqtt "github.com/Tomtao626/iothub/iotdevice/transport/mqtt" //go get -u github.com/tomtao626/iothub
  "log"
  "time"
)

func main() {

	c, err := iotdevice.NewFromConnectionString(
		iotmqtt.New(), "HostName=xxxx.azure-devices.cn;DeviceId=myDevice;SharedAccessKey=3k/K7JPeXrG+abUKlDkJbBqaB1D1POdfgd74G/AqY4daC2hXMvdAl1nW2Yfr7UGNvba2HRNhlUi9egqUbj6Hgbc1dg==",
	)
	if err != nil {
		log.Fatal(err)
	}
	// connect to the iothub
	if err = c.Connect(context.Background()); err != nil {
		log.Fatal(err)
	}
	// Regist Invoke DirectMethod
	if err := c.RegisterMethod(context.Background(), "TestMethod", DriectHandler); err != nil {
		log.Fatal(err)
	}
	time.Sleep(time.Hour * 30)
}

func DriectHandler(payload map[string]interface{}) (code int, response map[string]interface{}, err error) {
	fmt.Println("payload,", payload)
    return 200, map[string]interface{}{
      "result": payload["a"].(float64) + payload["b"].(float64),
    }, nil
}
```

## 6.6 设备孪生

### 6.6.1 设备孪生功能:

> + 将设备特定的元数据存储在云中。 例如，存储在自动售货机的部署位置。
> + 通过设备应用报告当前状态信息，例如可用功能和条件。 例如，是否通过移动电话网络或 WiFi 连接到 IoT 中心的设备。
> + 同步设备应用与后端应用之间的长时间运行工作流的状态。 例如，当解决方案后端指定要安装的新固件版本以及设备应用报告更新过程的各个阶段时。
> + 查询设备的元数据、配置或状态。

### 6.6.2 设备孪生包含:

> + 标记。 解决方案后端可从中读取和写入数据的 JSON 文档的某个部分。 标记对设备应用不可见。
> + 所需的属性。 与报告的属性结合使用，同步设备配置或状态。 解决方案后端可设置所需的属性，并且设备应用可进行读取。 此外，当所需的属性发生更改时，设备应用可收到通知。
> + 报告的属性。 与所需的属性结合使用，同步设备配置或状态。 设备应用可设置报告的属性，并且解决方案后端可进行读取和查询。
> + 设备标识属性。 设备孪生 JSON 文档的根包含标识注册表中存储的相应设备标识的只读属性。 不会包含属性 connectionStateUpdatedTime 和 generationId
> + ![](https://s3.bmp.ovh/imgs/2022/06/29/f7f38cadb54b4ef5.png)

### 6.6.3 设备孪生 JSON 文档示例

```json
{
    "deviceId": "devA",
    "etag": "AAAAAAAAAAc=", 
    "status": "enabled",
    "statusReason": "provisioned",
    "statusUpdateTime": "0001-01-01T00:00:00",
    "connectionState": "connected",
    "lastActivityTime": "2015-02-30T16:24:48.789Z",
    "cloudToDeviceMessageCount": 0, 
    "authenticationType": "sas",
    "x509Thumbprint": {     
        "primaryThumbprint": null, 
        "secondaryThumbprint": null 
    }, 
    "version": 2, 
    "tags": {
        "deploymentLocation": {
            "building": "43",
            "floor": "1"
        }
    },
    "properties": {
        "desired": {
            "telemetryConfig": {
                "sendFrequency": "5m"
            },
            "$metadata" : {},
            "$version": 1
        },
        "reported": {
            "telemetryConfig": {
                "sendFrequency": "5m",
                "status": "success"
            },
            "batteryLevel": 55,
            "$metadata" : {},
            "$version": 4
        }
    }
}
```

> + 根对象中包含设备标识属性，以及 `tags`、`reported` 和 `desired` 属性的容器对象。 `properties` 容器包含设备孪生元数据和乐观并发部分描述的一些只读元素（`$metadata` 和 `$version`）

### 6.6.4 后端操作设备孪生

> + 按 `ID` 检索设备孪生。 此操作返回设备孪生文档，包括标记、所需的系统属性和报告的系统属性。
> + 部分更新设备孪生。 解决方案后端可以使用此操作部分更新设备孪生中的标记或所需属性。 部分更新以 `JSON` 文档的形式表示，可添加或更新任何属性。 将删除设置为 `null` 的属性。
> + 以下示例创建值为 `{"newProperty": "newValue"}` 的新所需属性，将现有值 `existingProperty` 覆盖为 `otherNewValue`，并删除 `otherOldProperty`。 不会对现有的所需属性或标记进行其他任何更改

#### 6.6.4-1 创建/更新 新的所需属性

```json
{
     "properties": {
         "desired": {
             "newProperty": {
                 "nestedProperty": "newValue"
             },
             "existingProperty": "otherNewValue",
             "otherOldProperty": null
         }
     }
}
```

#### 6.6.4-2 设备孪生消息属性

> + 使用类似于 SQL 的 IoT 中心查询语言查询设备孪生。
> + 使用作业针对大型设备孪生集执行操作。
> + 替换所需属性。 解决方案后端可以使用此操作完全覆盖所有现有的所需属性，并使用新 `JSON` 文档替代 `properties/desired`。
> + 替换标记。 解决方案后端可以使用此操作完全覆盖所有现有标记，并使用新 `JSON` 文档替代 `tags`。
> + 接收孪生通知。 此操作允许解决方案后端在修改孪生时收到通知。 为此，`IoT` 解决方案需要创建一个路由，并且将“数据源”设置为等于 `twinChangeEvents`。 默认情况下没有此类路由预先存在，因此不会发送孪生通知。 如果更改速率太高，或由于其他原因（例如内部故障），`IoT` 中心可能会只发送一个包含所有更改的通知。 因此，如果应用程序需要可靠地审核和记录所有中间状态，则应使用设备到云消息。 孪生通知消息包括属性和正文。
    >  + 属性(消息系统属性以 $ 符号作为前缀。)

| 名称                     | Value                      |
|------------------------|----------------------------|
| $content-type	         | application/json           |
| $iothub-enqueuedtime	  | 发送通知的时间                    |
| $iothub-message-source | 	twinChangeEvents          |
| $content-encoding      | 	utf-8                     |
| deviceId               | 	设备 ID                     |
| hubName                | IoT 中心的名称                  |
| operationTimestamp     | ISO8601 操作时间戳              |
| iothub-message-schema	 | twinChangeNotification     |
| opType	                | “replaceTwin”或“updateTwin” |

> + 本部分包括 JSON 格式的所有孪生更改。 它使用与修补程序相同的格式，不同的是它可以包含所有孪生节：标记、properties.reported、properties.desired，并且它包含“$metadata”元素。 例如，

#### 6.6.4-4 设备孪生消息

```json
{
  "properties": {
      "desired": {
          "$metadata": {
              "$lastUpdated": "2016-02-30T16:24:48.789Z"
          },
          "$version": 1
      },
      "reported": {
          "$metadata": {
              "$lastUpdated": "2016-02-30T16:24:48.789Z"
          },
          "$version": 1
      }
  }
}
```

# 7 azure service-bus 数据处理

## 7.1 上报数据到服务总线

### 7.1.1 服务总线主题

**golang代码示例**

```go
package main

import (
	"context"
	"github.com/Azure/azure-sdk-for-go/sdk/messaging/azservicebus"
	"log"
)

func main() {
	client, err := azservicebus.NewClientFromConnectionString("Endpoint=sb://mroutesbus.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=mCRJzsFAk79WRmxspI+l5XIfXOUoTOxABOjatsI3C8Q=", nil)
	if err != nil {
		log.Fatal(err)
	}
	var queueTopicName string = "mytopic"
	sender, err := client.NewSender(queueTopicName, nil)
	sender.SendMessage(context.TODO(), &azservicebus.Message{
		Body: []byte("gggggggg!"),
	}, nil)
}

```

### 7.1.2 服务总线队列

**golang代码示例**

```go
package main

import (
	"context"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/to"
	"github.com/Azure/azure-sdk-for-go/sdk/messaging/azservicebus"
	"log"
)

func main() {
	client, err := azservicebus.NewClientFromConnectionString("Endpoint=sb://xxxx.servicebus.chinacloudapi.cn/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=8GadsaOISOAaexWlkW1asdasdzvmZlMWypOPeh0Q5nUdnuXBy9HY=", nil)
	if err != nil {
		log.Fatal(err)
	}
	var queueTopicName string = "queenName"
	sender, err := client.NewSender(queueTopicName, nil)
	sender.SendMessage(context.TODO(), &azservicebus.Message{
		ContentType: to.Ptr("application/json"),
		Body:        []byte("{'box':'kubernets xyzxyz!'}"),
	}, nil)
}

```

## 7.2 读取来自service bus内的数据

<a id="sb7-1">7.2.1 服务总线主题订阅</a>

**golang代码示例**

```go
package main

import (
	"context"
	"fmt"
	"github.com/Azure/azure-sdk-for-go/sdk/messaging/azservicebus" // go get github.com/Azure/azure-sdk-for-go/sdk/messaging/azservicebus
)

func main() {
	client, err := azservicebus.NewClientFromConnectionString("Endpoint=sb://mroutesbus.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=mCsfRsJzsFsdfAk79WsfsRmxspI+sfsl5XIfXOUhoTOxAdsBOsfsjatsI3C8Q=", nil)
	if err != nil {
		panic(err)
	}
	for {
		// receive message
		// mytopic是主题名称 S1是订阅名称
		receiver, err := client.NewReceiverForSubscription("mytopic", "S1", nil)
		if err != nil {
			panic(err)
		}
		message, err := receiver.ReceiveMessages(context.TODO(), 3, nil)
		if err != nil {
			panic(err)
		}
		for _, msg := range message {
			fmt.Println(string(msg.Body))
		}
	}
}
```

<a id="sb7-2">7.2.2 服务总线队列</a>

**golang代码示例**

```go
package main

import (
	"context"
	"fmt"
	"github.com/Azure/azure-sdk-for-go/sdk/messaging/azservicebus"
)

func main() {
	client, err := azservicebus.NewClientFromConnectionString("Endpoint=sb://xxxx.servicebus.chinacloudapi.cn/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=8GhOISOAaesfxWlkW1zvfsdfsmZlMWypOPeh0Q5nUdnuXBy9HY=", nil)
	if err != nil {
		panic(err)
	}
	for {
		receiver, err := client.NewReceiverForQueue("queenName", nil)
		if err != nil {
			panic(err)
		}
		message, err := receiver.ReceiveMessages(context.TODO(), 3, nil)
		if err != nil {
			panic(err)
		}
		for _, msg := range message {
			fmt.Println(string(msg.Body))
		}
	}
}
```
