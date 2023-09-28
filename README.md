# line-rails-app-sandbox

This repository is the setup and integration steps for incorporating LINE Login and LINE Messaging into a Ruby on Rails application.

## Dependency versions

* rails (7.0.8)
* devise (4.9.2)
* line-bot-api (1.28.0)
* typhoeus (1.4.0)

## Line Login

### Setting Up Environment Variables

Before proceeding, ensure that you have filled in the following environment variables in your server environment from [LINE Developers](https://developers.line.biz/console/):

    LINE_CHANNEL_ID
    LINE_CHANNEL_SECRET
    LINE_LOGIN_CALLBACK_URL=https://xxxx.ngrok-free.app/line_login_api/callback

### Running the Local Environment

Launch a local Rails server:

```bash
bin/rails s
```

Create a publicly accessible URL for your local server using Ngrok:

```bash
ngrok http 3000
```

Ngrok will generate a publicly accessible URL, e.g., https://xxxx.ngrok-free.app.

Open the generated URL for external access:

```bash
URL=https://xxxx.ngrok-free.app
open URL
```

### LINE Login Integration

1. Navigate to your Rails application's root page. 
2. Click on the *LINE Login* link. 
3. On the Line authentication page, click *Log in*. 
4. You will then receive a representation displaying your LINE user ID.

## LINE Messaging

### Setting Up Environment Variables

Before proceeding, ensure that you have filled in the following environment variables in your server environment from [LINE Developers](https://developers.line.biz/console/):

    LINE_CHANNEL_MESSAGE_ID
    LINE_CHANNEL_MESSAGE_SECRET
    LINE_CHANNEL_MESSAGE_TOKEN

### Setting up the Webhook URL in LINE Developers Console

Set the Webhook URL to *https://xxx.ngrok-free.app/line_message_api/callback*.

### LINE Messaging API Integration

1. Establish a connection with your LINE Official Account within your Line app. 
2. Receive a welcome greeting message from the LINE Official Account. 
3. Submit a message the letter 'A'.
4. Expect to receive a response message in return.

## Contributing
Bug reports and pull requests are welcome on Github at https://github.com/smapira. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Changelog
Available [here](https://github.com/smapira/blob/main/CHANGELOG.md).

## Code of Conduct
Everyone interacting in the project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/smapira/blob/main/CODE_OF_CONDUCT.md).

## Technology stacks
- [ngrok | Unified Ingress Platform for Developers](https://ngrok.com/)
- [LINE Developers](https://developers.line.biz/)
- [LINE Official Account Manager](https://manager.line.biz/)

## Аcknowledgments
- [Ruby on RailsのアプリにLINEを組み込む。 - Qiita](https://qiita.com/prg_mt/items/b3238ebfae1a3df67cab)
- [【Rails7】LINEログインを公式ドキュメントに沿って実装する](https://zenn.dev/yoiyoicho/articles/974c73ac75c100)

