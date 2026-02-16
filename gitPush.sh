#!/bin/bash

# Проверяем, находимся ли мы вообще в git-репозитории
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Ошибка: Здесь нет git-репозитория!"
  exit 1
fi

# Получаем имя текущей папки и URL удаленного репозитория
CURRENT_DIR=$(basename "$PWD")
REMOTE_URL=$(git config --get remote.origin.url)

echo "------------------------------------------------"
echo "ТЕКУЩИЙ РЕПОЗИТОРИЙ: $CURRENT_DIR"
echo "URL: $REMOTE_URL"
echo "------------------------------------------------"

# Запрашиваем сообщение коммита
echo "Введите сообщение коммита:"
read commit_message

# Проверка на пустое сообщение (чтобы не упал коммит)
if [ -z "$commit_message" ]; then
  echo "Ошибка: Сообщение коммита не может быть пустым!"
  exit 1
fi

# Запрашиваем ветку
echo "Введите ветку (по умолчанию main):"
read branch

if [ -z "$branch" ]; then
  branch="main"
fi

# Выполняем действия
git add .
git commit -m "$commit_message"
git push -u origin "$branch"

echo "Готово! Изменения отправлены в $branch."