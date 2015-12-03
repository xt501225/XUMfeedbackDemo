# XUMfeedback
友盟反馈自定义界面

##XUMfeedback是什么?
因为官方的反馈UI代码比较老，而且不太好看，所以利用友盟反馈sdk，写了一个新的反馈界面

##XUMfeedback效果展示

<img src="demo.png"/>

##XUMfeedback使用方法？

下载demo，直接将XUMfeedback文件夹拖拽到工程中，并修改XUMfeedback.h头文件进行简单配置。具体可以参考Demo。


##其他说明
* XUMfeedback包含UMfeedback sdk 3.8.0;
* 反馈界面使用了JSQMessagesViewController，并做了部分修改;
* UMfeedback的sdk中引用了UMFeedbackViewController，这是官方代码中的一个类。作为sdk，引入UI显然是不好的。
  所以XUMfeedback我新建了一个空的UMFeedbackViewController，防止编译出错。

