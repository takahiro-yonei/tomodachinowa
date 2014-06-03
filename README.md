# tomodachi no wa(トモダチの輪)

「トモダチの輪」は異なるSalesforce環境間でChatterを使ったコミュニケーションを支援するためのアプリケーションです。

もし、あなたがちょっと疲れたときに、特定のハッシュタグをつけてChatterでつぶやくと、それがどこかのSalesforce環境のユーザーに届きます。

そして、それをみたユーザーが何か一言励ましのコメントをつけると、そのコメントがあなたの元に戻ります。（そして癒されてくださいw）

逆に、他の誰かがつぶやいた一言が、あなたの環境に転送され、それに対してあなたが励ましのコメントを返すと、その「誰か」に届きます。（きっとあなたの一言で救われるでしょうw）

あなたの投稿が誰に届いたか、あるいは、あなたに届いた投稿は誰が発信したのかは、分かりません。ただそれがSalesforceを使う「仲間」に届いて、互いに励まし合うことが可能になります。

あなたの元に届いたメッセージ全てに応える必要はありません。でも、ちょっと励ましの言葉をかけることで、もしかしたら疲れてちょっと立ち止まっている「誰か」を救うことができるかもしれません。また、あなた自身が疲れて立ち止まっているときに、他の誰かが励ましの言葉をかけてくれて、勇気づけられるかもしれません。

このアプリを使って、そんなちょっとした「励まし」を交わすことができたらいいな、と思います。

- - -
※なお、これは[Crowdハッカソン②](https://crowdworks.jp/public/jobs/98707)の提案アプリとして作成したモノです。


## セットアップ

1. [パッケージ(非管理)](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t10000000VN9s)のインストール(Salesforce側)
    * このとき、「サードバーティアクセスの承認」というダイアログが表示されますので、チェックを入れて次へ進んでください。
1. Chatter自動転送用アカウントの作成(Salesforce側:推奨)
    * ChatterFreeライセンスで構いませんので、自身と異なるアカウント(a)を1つ用意してください。
1. ユーザー登録(Heroku側)
    * [herokuアプリ](https://tomodachinowa.herokuapp.com/)のサイトに移動して、"Sign in with Salesforce"のリンクをクリックしてください。
    * Salesforceへのログイン画面に移動しますので、先ほど作成したアカウント(a)でログインしてください。
    * 登録完了後、ユーザーID(b)が表示されますので、保管しておいてください。(後ほど使います)
1. システム設定(Salesforce側)
    * Configタブより、Configオブジェクトを新規作成してください。このときProxyUserIdには、(b)で保管したIDを入力してください。
    * (実際には、(a)のユーザーのSalesforceId(18桁)を、ProxyUserIdにセットしているだけとなります。)
    
以上で完了となります。

## 利用方法

* ちょっと疲れたときには...
    * ハッシュタグ(#癒されたい)をつけてChatterに投稿してください。

* (a)で作成したアカウントからの投稿には...
    * 他の誰かがちょっと疲れて投稿していますので、そのままコメントに励ましのメッセージを残してください。
    
## アーキテクチャなど
#### Salesforce

ユーザーからのChatter投稿で、特定のハッシュタグ(#癒されたい)があった場合、その内容をHerokuに転送します。

また、特定のハッシュタグ(#あなたの一言が誰かを救うかも)がある投稿に対してコメントした場合、その内容をHerokuに転送します。

#### Heroku

ユーザー情報、およびユーザーからの投稿や投稿を転送した記録を保持しています。

始めに登録する際のSalesforceへの認証では、[OmniAuth](https://github.com/intridea/omniauth),[OmniAuth-Salesforce](https://github.com/realdoug/omniauth-salesforce)を使っています。認証後に、ユーザーId,Email,暗号化したトークン等をheroku内に保存します。

Salesforceで投稿があって、Herokuに転送した場合、Heroku側で投稿元のユーザーを除いて、転送するユーザーをランダムに選択して、そのユーザーに対して投稿内容を転送します。また、この転送先を保存しておきます。

また、Salesforceで投稿に対するコメントがあって、Herokuに転送した場合、Heroku側で投稿元のユーザーを特定して、そのユーザーに対してコメント内容を転送します。

なお、HerokuからSalesforceへのアクセスには[force.rb](https://github.com/heroku/force.rb)を使っています。

## デモ用アカウント


※以下、デモ用アカウントでログインします。

[Demo1](https://login.salesforce.com/?un=dcmax-demo@taodrive.com&pw=y1awBd38uYz@As)

[Demo2](https://login.salesforce.com/?un=dcmax-friend@taodrive.com&pw=A2byCh97esZp@W)
