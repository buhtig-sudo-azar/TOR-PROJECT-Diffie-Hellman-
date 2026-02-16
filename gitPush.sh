#!/bin/bash

# Проверяем git-репозиторий
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Ошибка: Здесь нет git-репозитория!"
  exit 1
fi

CURRENT_DIR=$(basename "$PWD")
REMOTE_URL=$(git config --get remote.origin.url)

echo "------------------------------------------------"
echo "ТЕКУЩИЙ РЕПОЗИТОРИЙ: $CURRENT_DIR"
echo "URL: $REMOTE_URL"
echo "------------------------------------------------"

# Запрашиваем сообщение коммита (ТОЧНО как в примере)
echo -n "Введите сообщение коммита:"
read commit_message

# Проверка пустого сообщения
if [ -z "$commit_message" ]; then
  echo "Ошибка: Сообщение коммита не может быть пустым!"
  exit 1
fi

# Запрашиваем ветку (ТОЧНО как в примере)
echo -n "Введите ветку (по умолчанию main):"
read branch

# Автоопределение текущей ветки если пусто
if [ -z "$branch" ]; then
  branch=$(git branch --show-current)
fi

# Выполняем git команды
git add .
git commit -m "$commit_message"
git push origin "$branch"

echo "Готово! Изменения отправлены в $branch."
