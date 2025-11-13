import sys
from requests_html import HTMLSession

# --- 配置 ---
TARGET_URL = 'https://pc.weixin.qq.com/'
# CSS 选择器：精确匹配 a 标签，同时具备 class 和 id 属性
CSS_SELECTOR = 'a.download-button#downloadButton'
# --- 配置结束 ---

try:
    session = HTMLSession()
    # render=True 这一步会启动一个无头浏览器来执行页面上的 JavaScript
    r = session.get(TARGET_URL)
    r.html.render(sleep=3, timeout=10) # 延迟 3 秒确保 JavaScript 渲染完成
    
    # 使用 CSS 选择器查找元素
    element = r.html.find(CSS_SELECTOR, first=True)

    if element and element.attrs.get('href'):
        link = element.attrs['href']
        
        # 补全协议头（如果链接是以 // 开头）
        if link.startswith('//'):
            link = "https:" + link
            
        print(link)
    else:
        # 如果找不到匹配的元素
        sys.stderr.write(f"Error: Could not find element matching selector '{CSS_SELECTOR}'\n")
        sys.exit(1)

except Exception as e:
    sys.stderr.write(f"An error occurred: {e}\n")
    sys.exit(1)
