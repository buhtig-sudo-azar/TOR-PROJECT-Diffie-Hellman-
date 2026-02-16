#!/bin/bash

set -e

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
[[ -z "$commit_message" ]] && { echo "❌ Пустое сообщение!"; exit 1; }

# 🔥 ЧТЕНИЕ .gitignore и АВТООЧИСТКА
echo "🧹 Читаем .gitignore и очищаем..."
if [ -f .gitignore ]; then
  # Находим ВСЕ файлы, которые в индексе Git НО должны игнорироваться
  while IFS= read -r pattern; do
    [[ -z "$pattern" || "$pattern" =~ ^# ]] && continue
    
    # Проверяем каждый файл в индексе по паттерну .gitignore
    git ls-files | while IFS= read -r file; do
      if [[ -n "$file" && "$file" =~ $pattern ]]; then
        if git ls-files --error-unmatch "$file" 2>/dev/null; then
          git rm --cached "$file" 2>/dev/null && echo "  ✅ Очищен: $file"
        fi
      fi
    done
  done < .gitignore
fi

# Коммит очистки
if ! git diff --cached --quiet; then
  git add .gitignore
  git commit -m "🧹 cleanup: sync with .gitignore"
  echo "✅ .gitignore синхронизирован"
fi

echo "🌳 ВСЕ ВЕТКИ:"
mapfile -t branches < <(git branch -a --format="%(refname:short)" | sed 's/origin\///' | sort -u)
for i in "${!branches[@]}"; do
  [[ "${branches[i]}" == "$CURRENT_BRANCH" ]] && \
    printf "  ✓ %d. %s (ТЕКУЩАЯ)\n" $((i+1)) "${branches[i]}" || \
    printf "    %d. %s\n" $((i+1)) "${branches[i]}"
done

echo -n "🎯 Номер ветки (Enter=$CURRENT_BRANCH): "
read choice

if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#branches[@]} ]; then
  TARGET_BRANCH="${branches[$((choice-1))]}"
elif [[ -z "$choice" ]]; then
  TARGET_BRANCH="$CURRENT_BRANCH"
else
  echo "❌ Неверный выбор!"
  exit 1
fi

echo "➤ $TARGET_BRANCH"

# 🔄 ПЕРЕКЛЮЧЕНИЕ
if [[ "$TARGET_BRANCH" != "$CURRENT_BRANCH" ]]; then
  echo "🔄 checkout $TARGET_BRANCH..."
  git stash push -m "gitadd-temp" 2>/dev/null || true
  git checkout "$TARGET_BRANCH" || git checkout -b "$TARGET_BRANCH" "origin/$TARGET_BRANCH" 2>/dev/null || { git stash pop 2>/dev/null; exit 1; }
  git stash pop 2>/dev/null || true
  CURRENT_BRANCH=$(git branch --show-current)
  echo "✅ Теперь: $CURRENT_BRANCH"
fi

# ✅ КОММИТ если есть изменения
if ! git diff --quiet; then
  git add -A
  if ! git diff --cached --quiet; then
    git commit -m "$commit_message"
    git push origin "$CURRENT_BRANCH"
    echo "✅ '$commit_message' → $CURRENT_BRANCH"
  else
    echo "ℹ️ Нет изменений после add"
  fi
else
  echo "ℹ️ Нет изменений"
fi
