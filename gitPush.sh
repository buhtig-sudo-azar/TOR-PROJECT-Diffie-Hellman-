#!/bin/bash

set -e  # Выход при ошибке

if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "❌ Здесь нет git-репозитория!"
  exit 1
fi

CURRENT_DIR=$(basename "$PWD")
REMOTE_URL=$(git config --get remote.origin.url)
CURRENT_BRANCH=$(git branch --show-current)

echo "===================================================="
echo "📁 $CURRENT_DIR"
echo "🔗 $REMOTE_URL"
echo "🌿 $CURRENT_BRANCH"
echo "===================================================="

echo -n "💬 Сообщение коммита: "
read commit_message

if [ -z "$commit_message" ]; then
  echo "❌ Сообщение пустое!"
  exit 1
fi

# 🔥 АВТООЧИСТКА игнорируемых файлов
echo "🧹 Очистка..."
for file in venv/ __pycache__/ tor_demo.sh env.sh settings; do
  git rm -r --cached "$file" 2>/dev/null || true
done

# Коммит очистки если нужно
if ! git diff --cached --quiet; then
  git add .gitignore
  git commit -m "🧹 cleanup: ignore files"
  echo "✅ Игнор очищен"
fi

echo "🌳 ВЕТКИ:"
mapfile -t branches < <(git branch -a --format="%(refname:short)" | sed 's/origin\///' | sort -u)
for i in "${!branches[@]}"; do
  if [ "${branches[i]}" = "$CURRENT_BRANCH" ]; then
    printf "  ✓ %d. %s (ТЕКУЩАЯ)\n" $((i+1)) "${branches[i]}"
  else
    printf "    %d. %s\n" $((i+1)) "${branches[i]}"
  fi
done

echo -n "🎯 Номер ветки (Enter=$CURRENT_BRANCH): "
read choice

if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#branches[@]} ]; then
  TARGET_BRANCH="${branches[$((choice-1))]}"
elif [ -z "$choice" ]; then
  TARGET_BRANCH="$CURRENT_BRANCH"
else
  echo "❌ Неверный выбор!"
  exit 1
fi

echo "➤ $TARGET_BRANCH"

# 🔄 ПЕРЕКЛЮЧЕНИЕ ВЕТКИ с сохранением изменений
if [ "$TARGET_BRANCH" != "$CURRENT_BRANCH" ]; then
  echo "🔄 checkout $TARGET_BRANCH..."
  git stash push -m "gitadd-temp" 2>/dev/null || true
  if git show-ref --verify --quiet refs/heads/"$TARGET_BRANCH" 2>/dev/null; then
    git checkout "$TARGET_BRANCH"
  else
    git checkout -b "$TARGET_BRANCH" "origin/$TARGET_BRANCH" 2>/dev/null || git checkout "$TARGET_BRANCH"
  fi
  git stash pop 2>/dev/null || true
  CURRENT_BRANCH=$(git branch --show-current)
  echo "✅ Теперь: $CURRENT_BRANCH"
fi

# ✅ ПРОВЕРКА ИЗМЕНЕНИЙ
if git diff --quiet && git diff --cached --quiet; then
  echo "ℹ️  Нет изменений"
  exit 0
fi

# 🚀 ОСНОВНОЙ КОММИТ+ПУШ
git add -A
if ! git diff --cached --quiet; then
  git commit -m "$commit_message"
  git push origin "$CURRENT_BRANCH"
  echo "✅ '$commit_message' → $CURRENT_BRANCH"
else
  echo "ℹ️  Пустой коммит"
fi
