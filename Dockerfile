FROM ruby:2.7.2

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && apt-get update \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y build-essential \
  libpq-dev \
  nodejs \
  yarn

RUN mkdir /react

ENV APP_ROOT /react-app
WORKDIR $APP_ROOT

ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock

RUN bundle install
ADD . $APP_ROOT

# ローカル開発環境のstart.shの内容をDockerコンテナ上の/start.shにコピー
COPY start.sh /start.sh
# Docker側の下記のファイルに実行権限を渡すので権限を変更する
RUN chmod 744 /start.sh
# 実行
CMD ["sh", "/start.sh"]