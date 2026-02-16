#!/bin/bash
# tor_demo.sh - Интерактивное объяснение алгоритма Диффи-Хеллмана в Tor

set -e
SERVER_HOST="localhost"
SERVER_PORT="8080"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"  # Директория скрипта
SCRIPT_NAME="$(basename "$0")"               # Имя скрипта

# Функция генерации HTML (используем временный файл)
generate_html() {
    cat > /tmp/tor_dh_page.html <<'HTML_EOF'
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <title>🔐 Tor: алгоритм Диффи-Хеллмана</title>
    <style>
        body { 
            font-family: 'Segoe UI', Arial, sans-serif; 
            margin: 2rem; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            padding: 2rem;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        h1 { 
            color: #2d3748; 
            text-align: center;
            font-size: 2.5rem;
            margin-bottom: 2rem;
            border-bottom: 3px solid #667eea;
            padding-bottom: 1rem;
        }
        h2 { color: #4a5568; margin-top: 1.5rem; }
        h3 { color: #2d3748; margin-top: 1rem; }
        .step-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
            margin: 2rem 0;
        }
        .card {
            background: #f7fafc;
            border-radius: 15px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.2s;
            border: 2px solid transparent;
        }
        .card:hover {
            transform: translateY(-5px);
            border-color: #667eea;
        }
        .card h3 {
            color: #2d3748;
            margin-top: 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .param {
            background: #edf2f7;
            padding: 1rem;
            border-radius: 10px;
            font-family: 'Courier New', monospace;
            margin: 1rem 0;
            border-left: 4px solid #667eea;
        }
        .key-value {
            background: #2d3748;
            color: #fbbf24;
            padding: 1rem;
            border-radius: 10px;
            text-align: center;
            font-size: 1.2rem;
            font-weight: bold;
            margin: 1rem 0;
        }
        .tooltip-icon {
            display: inline-block;
            width: 20px;
            height: 20px;
            background: #667eea;
            color: white;
            border-radius: 50%;
            text-align: center;
            line-height: 20px;
            font-size: 12px;
            cursor: help;
            margin-left: 5px;
        }
        .tooltip {
            position: fixed;
            z-index: 9999;
            pointer-events: none;
            opacity: 0;
            visibility: hidden;
            background: #2d3748;
            color: white;
            padding: 10px 15px;
            border-radius: 8px;
            font-size: 14px;
            max-width: 300px;
            transition: opacity 0.2s;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            border: 1px solid #667eea;
        }
        .tooltip::after {
            content: '';
            position: absolute;
            top: 100%;
            left: 50%;
            transform: translateX(-50%);
            border: 6px solid transparent;
            border-top-color: #2d3748;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 2rem 0;
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }
        th {
            background: #667eea;
            color: white;
            padding: 1rem;
            font-weight: 600;
        }
        td {
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
            text-align: center;
        }
        tr:hover {
            background: #f7fafc;
        }
        .info-box {
            background: #ebf4ff;
            border-radius: 10px;
            padding: 1.5rem;
            margin: 2rem 0;
            border-left: 4px solid #667eea;
        }
        .magic-box {
            background: #fef3c7;
            border-radius: 10px;
            padding: 1.5rem;
            margin: 2rem 0;
            border-left: 4px solid #fbbf24;
        }
        .math-detail {
            background: #1e293b;
            color: #e2e8f0;
            padding: 1rem;
            border-radius: 8px;
            font-family: 'Courier New', monospace;
            margin: 1rem 0;
            overflow-x: auto;
        }
        .math-detail .highlight {
            color: #fbbf24;
            font-weight: bold;
        }
        .sse-status {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: #2d3748;
            color: #4ade80;
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.8rem;
            z-index: 1000;
            border: 1px solid #4ade80;
            transition: all 0.3s;
        }
        button {
            background: #667eea;
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 10px;
            font-size: 1rem;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 1rem;
        }
        button:hover {
            background: #5a67d8;
        }
        .badge {
            background: #48bb78;
            color: white;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: bold;
            display: inline-block;
        }
    </style>
</head>
<body>
    <div class="container">
<<<<<<< Updated upstream
        <h1>🧅 Tor: алгоритм Диффи-Хеллмана (Diffie-Hellman)</h1>
=======
        <h1> Tor: алгоритм Диффи-Хеллмана (Diffie-Hellman)</h1>
>>>>>>> Stashed changes
        
        <div class="info-box">
            <strong>📚 Для новичков:</strong> Диффи-Хеллман — это способ, с помощью которого два человека могут договориться об общем секретном ключе, даже если все их разговоры кто-то подслушивает. Этот алгоритм используется в Tor для установки шифрованного соединения между узлами.
        </div>

        <h2>🔢 Шаг 1: Открытые параметры (известны всем)</h2>
        <div class="step-grid">
            <div class="card">
                <h3>p (простое число) <span class="tooltip-icon" data-tooltip="Большое простое число, известное всем участникам. В реальности оно огромное (2048 бит)">?</span></h3>
                <div class="key-value">p = 23</div>
            </div>
            <div class="card">
                <h3>g (первообразный корень) <span class="tooltip-icon" data-tooltip="Основание степени, тоже общеизвестное">?</span></h3>
                <div class="key-value">g = 5</div>
            </div>
        </div>

        <h2>🤝 Шаг 2: Секретные ключи участников</h2>
        <div class="step-grid">
            <div class="card">
                <h3>👩 Алиса (клиент Tor)</h3>
                <div class="badge">Секретно</div>
                <div class="param">Случайное число a = <strong>6</strong></div>
                <p>Вычисляет открытый ключ A = g^a mod p</p>
                <div class="key-value">A = 5⁶ mod 23 = 8</div>
                <p><small>🔓 Открытый ключ A можно передавать по сети</small></p>
            </div>
            <div class="card">
                <h3>👨 Боб (сервер Tor)</h3>
                <div class="badge">Секретно</div>
                <div class="param">Случайное число b = <strong>15</strong></div>
                <p>Вычисляет открытый ключ B = g^b mod p</p>
                <div class="key-value">B = 5¹⁵ mod 23 = 19</div>
                <p><small>🔓 Открытый ключ B можно передавать по сети</small></p>
            </div>
        </div>

        <h2>📡 Шаг 3: Обмен открытыми ключами</h2>
        <div class="card" style="text-align: center;">
            <p style="font-size: 1.2rem;">👩 Алиса ——— (A=8) ———→ 👨 Боб</p>
            <p style="font-size: 1.2rem;">👩 Алиса ←—— (B=19) ——— 👨 Боб</p>
            <p><span class="tooltip-icon" data-tooltip="Ева (злоумышленница) видит числа 8 и 19, но не может вычислить a или b">?</span> Даже если кто-то перехватит A и B, он не узнает секретные a и b</p>
        </div>

        <h2>🔐 Шаг 4: Вычисление общего секрета</h2>
        <div class="step-grid">
            <div class="card">
                <h3>👩 Алиса вычисляет</h3>
                <div class="param">S = B^a mod p</div>
                <div class="key-value">S = 19⁶ mod 23 = 2</div>
                <p><small>Использует свой секретный a и открытый B Боба</small></p>
            </div>
            <div class="card">
                <h3>👨 Боб вычисляет</h3>
                <div class="param">S = A^b mod p</div>
                <div class="key-value">S = 8¹⁵ mod 23 = 2</div>
                <p><small>Использует свой секретный b и открытый A Алисы</small></p>
            </div>
        </div>

        <div class="card" style="background: #c6f6d5; border-color: #48bb78;">
            <h3 style="color: #22543d; text-align: center;">✅ Общий секретный ключ получен!</h3>
            <div class="key-value" style="background: #22543d; color: #fbbf24; font-size: 2rem;">S = 2</div>
            <p style="text-align: center;">Это число знают только Алиса и Боб. В Tor из него с помощью хеш-функции создаётся сеансовый ключ для шифрования.</p>
        </div>

        <!-- ========== НОВЫЙ БЛОК С ОБЪЯСНЕНИЕМ МАГИИ МОДУЛЕЙ ========== -->
        <div class="magic-box">
            <h2>🧙‍♂️ Почему получается одно и то же число? Магия модулей!</h2>
            
            <h3>📐 Математическое свойство:</h3>
            <div class="math-detail">
                (g^a mod p)^b mod p = g^(a*b) mod p = (g^b mod p)^a mod p
            </div>
            <p>Операции возведения в степень и взятия модуля можно менять местами! Это работает благодаря законам модульной арифметики.</p>
            
            <h3>🔬 Разбор на числах из примера:</h3>
            
            <h4>👩 Алиса получила B = 19, но что такое 19 на самом деле?</h4>
            <div class="math-detail">
                B = 19 = <span class="highlight">5^15 mod 23</span>
            </div>
            <p>Алиса вычисляет:</p>
            <div class="math-detail">
                S = B^a mod p = (5^15 mod 23)^6 mod 23<br>
                = <span class="highlight">5^(15*6) mod 23</span> = 5^90 mod 23
            </div>
            
            <h4>👨 Боб получил A = 8, а это:</h4>
            <div class="math-detail">
                A = 8 = <span class="highlight">5^6 mod 23</span>
            </div>
            <p>Боб вычисляет:</p>
            <div class="math-detail">
                S = A^b mod p = (5^6 mod 23)^15 mod 23<br>
                = <span class="highlight">5^(6*15) mod 23</span> = 5^90 mod 23
            </div>
            
            <h4>✨ Оба получили одно и то же:</h4>
            <div class="math-detail" style="font-size: 1.5rem; text-align: center;">
                5<span class="highlight">⁹⁰</span> mod 23 = 2
            </div>
            
            <h3>🧮 А вот ЕВА (злоумышленница) видит только:</h3>
            <div class="math-detail">
                p = 23, g = 5<br>
                A = 5^6 mod 23 = 8<br>
                B = 5^15 mod 23 = 19
            </div>
            <p>Чтобы получить секрет, ей нужно вычислить 5^(a*b) mod 23, зная только 5^a и 5^b.</p>
            <p>Это называется <strong>проблема дискретного логарифма</strong> - для больших чисел (2048 бит) это практически невозможно!</p>
            
            <h3>🎨 Аналогия с красками:</h3>
            <ul>
                <li><strong>Желтая краска (g, p)</strong> - известна всем</li>
                <li><strong>Красный (a)</strong> - секрет Алисы</li>
                <li><strong>Синий (b)</strong> - секрет Боба</li>
                <li><strong>Оранжевый (A)</strong> - желтый + красный</li>
                <li><strong>Голубой (B)</strong> - желтый + синий</li>
                <li><strong>Коричневый (S)</strong> - оранжевый + синий = голубой + красный = <strong>ОДИНАКОВЫЙ!</strong></li>
            </ul>
        </div>
        <!-- ========== КОНЕЦ НОВОГО БЛОКА ========== -->

        <h2>📊 Сравнение с другими алгоритмами</h2>
        <table>
            <thead>
                <tr>
                    <th>Алгоритм</th>
                    <th>Применение в Tor</th>
                    <th>Сложность взлома</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><strong>Diffie-Hellman</strong></td>
                    <td>Установка общего ключа</td>
                    <td>Дискретное логарифмирование</td>
                </tr>
                <tr>
                    <td>AES-256</td>
                    <td>Шифрование данных</td>
                    <td>Практически невозможно</td>
                </tr>
                <tr>
                    <td>RSA</td>
                    <td>Цифровые подписи</td>
                    <td>Факторизация чисел</td>
                </tr>
            </tbody>
        </table>

        <div style="margin-top:20px; text-align: center;">
            <button data-tooltip="Страница автообновляется при изменении скрипта" onmouseenter="showTooltip(event)" onmouseleave="hideTooltip()">
                🔄 Информация
            </button>
        </div>
    </div>

    <div id="global-tooltip" class="tooltip"></div>
    <div id="sse-status" class="sse-status">⚡ Сервер: активен</div>

    <script>
        function showTooltip(event) {
            const tooltip = document.getElementById('global-tooltip');
            const text = event.target.getAttribute('data-tooltip');
            if (!text) return;
            tooltip.textContent = text;
            tooltip.style.opacity = '1';
            tooltip.style.visibility = 'visible';
            tooltip.style.left = (event.clientX + 15) + 'px';
            tooltip.style.top = (event.clientY + 15) + 'px';
        }

        function hideTooltip() {
            const tooltip = document.getElementById('global-tooltip');
            tooltip.style.opacity = '0';
            tooltip.style.visibility = 'hidden';
        }

        document.querySelectorAll('[data-tooltip]').forEach(el => {
            el.addEventListener('mouseenter', showTooltip);
            el.addEventListener('mouseleave', hideTooltip);
        });

        // Проверка изменений через HEAD запросы
        let lastModified = null;
        async function checkForChanges() {
            try {
                let res = await fetch('/tor_dh_page.html', { method: 'HEAD' });
                let modified = res.headers.get('last-modified');
                if (lastModified && modified !== lastModified) {
                    console.log('🔄 Обнаружены изменения, перезагрузка...');
                    location.reload();
                }
                lastModified = modified;
            } catch(e) {}
        }
        setInterval(checkForChanges, 2000);
    </script>
</body>
</html>
HTML_EOF
}

# Генерируем начальный HTML
generate_html

echo "✅ Сервер запущен: http://$SERVER_HOST:$SERVER_PORT/tor_dh_page.html"
echo "📁 Файл: /tmp/tor_dh_page.html"
echo "👀 Watchdog следит за изменениями в: $SCRIPT_DIR/"
echo "✏️  Измените этот скрипт → HTML обновится автоматически"
echo "🛑 Остановка: Ctrl+C"

cd /tmp && python3 -c "
import http.server
import socketserver
import os
import time
import subprocess
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

<<<<<<< Updated upstream
=======
print('🐍 Python сервер запущен')
print(f'📂 Рабочая директория: {os.getcwd()}')
print(f'📄 Файл tor_dh_page.html существует: {os.path.exists(\"tor_dh_page.html\")}')
print('==================================')

>>>>>>> Stashed changes
class ScriptHandler(FileSystemEventHandler):
    def on_modified(self, event):
        # Если изменился наш скрипт
        if os.path.basename(event.src_path) == '$SCRIPT_NAME':
            print(f'\\n🔄 Скрипт изменён: $SCRIPT_NAME')
            print('   Перегенерирую HTML...')
            
            try:
                # Извлекаем HTML из скрипта
                script_path = os.path.join('$SCRIPT_DIR', '$SCRIPT_NAME')
                
                with open(script_path, 'r') as f:
                    content = f.read()
                
                # Ищем часть между 'cat > /tmp/tor_dh_page.html <<'\''HTML_EOF'\' и 'HTML_EOF'
                start_marker = \"cat > /tmp/tor_dh_page.html <<'HTML_EOF'\"
                end_marker = \"HTML_EOF\"
                
                start_idx = content.find(start_marker)
                if start_idx != -1:
                    start_idx += len(start_marker)
                    end_idx = content.find(end_marker, start_idx)
                    
                    if end_idx != -1:
                        html_content = content[start_idx:end_idx].strip()
                        
                        # Записываем в файл
                        with open('/tmp/tor_dh_page.html', 'w') as f:
                            f.write(html_content)
                        
                        print('✅ HTML перегенерирован')
                        # Обновляем кэш
                        StrictHandler.reload_content()
                    else:
                        print('❌ Не найден конец HTML блока')
                else:
                    print('❌ Не найден HTML блок в скрипте')
                    
            except Exception as e:
                print(f'❌ Ошибка: {e}')

class StrictHandler(http.server.BaseHTTPRequestHandler):
    cached_content = None
    
    @classmethod
    def reload_content(cls):
        try:
            with open('tor_dh_page.html', 'rb') as f:
                cls.cached_content = f.read()
            print('✅ Контент обновлён в кэше')
            return True
        except Exception as e:
            print(f'❌ Ошибка загрузки контента: {e}')
            return False
    
    def do_GET(self):
        if self.path == '/tor_dh_page.html':
            if self.cached_content is None:
                self.reload_content()
            
            self.send_response(200)
            self.send_header('Content-type', 'text/html; charset=utf-8')
            self.send_header('Last-Modified', time.strftime('%a, %d %b %Y %H:%M:%S GMT', time.gmtime(os.path.getmtime('tor_dh_page.html'))))
            self.end_headers()
            self.wfile.write(self.cached_content)
        else:
            self.send_error(404, 'File not found')
    
    def log_message(self, format, *args):
        pass

# Освобождаем порт если занят
try:
    result = subprocess.run(['lsof', '-ti', f':$SERVER_PORT'], capture_output=True, text=True)
    if result.stdout:
        pids = result.stdout.strip().split('\n')
        for pid in pids:
            if pid:
                print(f'🔄 Освобождаю порт $SERVER_PORT (PID: {pid})')
                subprocess.run(['kill', '-9', pid], capture_output=True)
        time.sleep(1)
except:
    pass

with socketserver.TCPServer(('$SERVER_HOST', $SERVER_PORT), StrictHandler) as httpd:
    print('🔐 Сервер запущен. Листинг директорий ЗАПРЕЩЁН.')
    print(f'📄 Доступен только: http://$SERVER_HOST:$SERVER_PORT/tor_dh_page.html')
    
    observer = Observer()
    event_handler = ScriptHandler()
    
    # Следим за директорией со скриптом
    observer.schedule(event_handler, path='$SCRIPT_DIR', recursive=False)
    observer.start()
    print(f'👀 Наблюдатель запущен. Слежу за изменениями в: $SCRIPT_DIR/')
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print('\\n🛑 Останавливаю наблюдателя...')
        observer.stop()
    observer.join()
    print('🛑 Сервер остановлен.')
"