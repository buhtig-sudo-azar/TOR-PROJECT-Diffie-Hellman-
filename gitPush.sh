#!/bin/bash
set -euo pipefail  # Выход при ошибке, unset vars, pipefail [web:12]

# Проверяем git-репозиторий
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Ошибка: Здесь нет git-репозитория!"
  exit 1
fi

CURRENT_DIR=$(basename "$PWD")
REMOTE_URL=$(git config --get remote.origin.url)

echo "------------------------------------------------"
echo "РЕПОЗИТОРИЙ: $CURRENT_DIR"
echo "URL: $REMOTE_URL"
echo "------------------------------------------------"

# Сообщение коммита
echo "Сообщение коммита:"
read -r commit_message
if [ -z "$commit_message" ]; then
  echo "Ошибка: Сообщение не может быть пустым!"
  exit 1
fi

# Ветка
echo "Ветка (по умолчанию main):"
read -r branch
branch=${branch:-main}

# Проверка изменений
if ! git diff --quiet || ! git diff --cached --quiet; then
  git add .
  git commit -m "$commit_message"
  echo "Коммит создан."
else
  echo "Нет изменений для коммита."
  exit 0
fi

# Pull с rebase перед push [web:15]
echo "Pull с rebase из origin/$branch?"
git pull --rebase origin "$branch" || {
  echo "Конфликты в pull: разрешите вручную (git rebase --continue)."
  exit 1
}

# Подтверждение push
echo "Push в $branch? (y/n)"
read -r confirm
if [[ "$confirm" =~ ^[Yy] ]]; then
  git push origin "$branch"
fi

echo "Готово!"
