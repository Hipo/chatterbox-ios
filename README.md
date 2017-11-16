# Chatterbox

Plug and play chat library for iOS

## Requirements

* iOS 9+
* Swift 3

To create chat interface, websocket and data provider protocols should be implemented. Otherwise, fatal errors will be shown. 

All chat messages are in a chat thread.


## Dependencies

* IGListKit
* SocketRocket
* SnapKit

If you find any issues, please open an issue here on GitHub, and feel free to send in pull requests with improvements and fixes. You can also get in touch by emailing us at [hello@hipolabs.com](mailto:hello@hipolabs.com).

## Usage

Creating chat interface view controller

```swift
let chatThread = ChatThreadable()

let dataProvider = DataProvider(thread: chatThread)
let socketProvider = SocketProvider(thread: chatThread)

let vc = ChatViewController(dataProvider: dataProvider,
webSocketProvider: socketProvider)

vc.chatInputAccessoryView = FLChatInputAccessoryView()
```

Required protocols should be wrapped up. 

**Data Provider**

```swift
class DataProvider: BaseChatInterfaceDataProvider<ChatThreadable, ChatMessage> {
    override var canLoadMoreChatMessages: Bool {
        return false
    }

    init(thread: ChatThreadable?) {
        super.init(chatThread: thread)
    }

    override func loadChatMessages(previous: Bool) {
        loadChatMessagesWasCompleted(previous: previous, with: nil)
    }

    override func send(_ chatDraftMessage: ChatDraftMessage,
                       onCompletion completion: ((Error?) -> Void)?) {

    let chatMessage = ChatMessage()

    chatMessage.text = "Test chatbox"

    completion?(nil)

    //Insert chat message to chat thread
    load(chatMessage)
    }
}
```

**Socket Provider**

```swift
class SocketProvider: BaseChatInterfaceWebSocketProvider<ChatThreadable> {
    init(thread: ChatThreadable?) {
        super.init(chatThread: thread)
    }

    override var chatServerUrl: String? { return nil }
    override func setupConnection() {}
    override func openConnection() {}
    override func closeConnection() {}
}

```

**Data Controller**

```swift
class DataController: ChatMessageDataController {
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 20.0
        
        return CGSize(width: width, height: 100.0)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let chatMessage = chatMessage else {
            return super.cellForItem(at: index)
        }
        
      guard let cell = collectionContext?.dequeueReusableCell(
            of: MyCell.self,
            for: self,
            at: index) as? MyCell else {
                return super.cellForItem(at: index)
        }
        
        switch chatMessage.type {
        case .text(let text):
            cell.messageView.textLabel.text = text
        case .attributedText(let attributedText):
            cell.messageView.textLabel.attributedText = attributedText
        default:
            break
        }

        return cell
    }
```

**Message Cell**

```swift

class MessageCell: ChatMessageCell<MessageView> {
    
    override func setupLayout() {
        
        buildMessageView()
        
        contentView.addSubview(messageView)
        
        messageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        setupMessageLabelLayout()
    }
    
    func buildMessageView() {
        messageView = builder.build()
    }
    
    func setupMessageLabelLayout() {
        
        let textLabel = messageView.textLabel
        
        messageView.contentView.addSubview(textLabel)
        
        textLabel.setContentHuggingPriority(999, for: .vertical)
        textLabel.snp.remakeConstraints({ (make) in
            make.top.equalToSuperview().inset(10.0)
            make.leading.equalToSuperview().inset(10.0)
            make.trailing.equalToSuperview().inset(10.0)
        })
    }
    
    override class func calculateHeight(with chatMessage: ChatMessageRepresentable,
                                        constrainedTo width: CGFloat) -> CGFloat {
        var height: CGFloat = 75.0
        
        return height
    }
}

class MyCell: MessageCell {
    
    override func setupLayout() {
        super.setupLayout()
        
        backgroundColor = UIColor.purple
        layer.cornerRadius = 4.0
    }
}

class MessageView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private(set) lazy var contentView: UIView = UIView()
    
    private(set) lazy var textLabel: UILabel = {
        [unowned self] in
        
        let label = UILabel()
        
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14.0)
        
        return label
        }()
}

extension MessageView: ChatMessageViewRepresentable {
    var view: UIView {
        return self
    }
    
    var contentBackgroundView: UIView? {
        return nil
    }
    
    var contentMessageView: UIView? {
        return nil
    }
    
    var contentFooterSupplementaryView: UIView? {
        return nil
    }
    
    var senderView: UIView? {
        return nil
    }
}


```

You can specify your message & thread object with extending *ChatThreadRepresentable* *ChatMessageRepresentable* protocols.

---
**Warning**

Chat interface works properly with **Data Provider** and **Socket Provider**. So if you want to use REST API instead of Socket, you need to follow Example project. Otherwise, your message may be seen twice.

## Example

There is a local example project to create Chat Interface. 

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Protocols 

*ChatThreadRepresentable*

*ChatMessageRepresentable*

## Installation

Chatterbox is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod 'Chatterbox'
```

## Credits

Chatterbox is brought to you by [Hipo Team](http://hipolabs.com).

## License

Chatterbox is available under the MIT license. See the LICENSE file for more info.
