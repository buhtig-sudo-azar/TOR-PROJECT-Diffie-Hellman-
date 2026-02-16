#!/bin/bash

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Ошибка: Здесь нет git-репозитория!"
  exit 1
fi

CURRENT_DIR=$(basename "$PWD")
REMOTE_URL=$(git config --get remote.origin.url)
CURRENT_BRANCH=$(git branch --show-current)

echo "------------------------------------------------"
echo "ТЕКУЩИЙ РЕПОЗИТОРИЙ: $CURRENT_DIR"
echo "URL: $REMOTE_URL"
echo "ТЕКУЩАЯ ВЕТКА: $CURRENT_BRANCH"
echo "------------------------------------------------"

echo -n "Введите сообщение коммита: "
read commit_message

if [ -z "$commit_message" ]; then
  echo "Ошибка: Сообщение пустое!"
  exit 1
fi

echo "ВЕТКИ:"
mapfile -t branches < <(git branch --format="%(refname:short)")
for i in "${!branches[@]}"; do
  printf "  %d. %s\n" $((i+1)) "${branches[i]}"
done

echo -n "НОМЕР ВЕТКИ (Enter=$CURRENT_BRANCH): "
read choice

if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#branches[@]} ]; then
  branch="${branches[$((choice-1))]}"
elif [ -z "$choice" ]; then
  branch="$CURRENT_BRANCH"
else
  echo "НЕВЕРНЫЙ ВЫБОР!"
  exit 1
fi

echo "ВЫБРАНА: $branch"

git add .
git commit -m "$commit_message"
git push origin "$branch"

echo "ГОТОВО! Отправлено в $branch."
