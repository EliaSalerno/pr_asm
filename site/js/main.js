// Constants for Navigation
const views = {
    home: document.getElementById('home-view'),
    markdown: document.getElementById('markdown-view')
};

const navTeoria = document.getElementById('nav-teoria');
const navPratica = document.getElementById('nav-pratica');

const markdownContent = document.getElementById('markdown-content');

// Load dynamic navigation on startup
function initializeNav() {
    // Teoria
    const teoriaEntries = Object.keys(repoData.teoria).sort();
    teoriaEntries.forEach(key => {
        const entry = repoData.teoria[key];
        const li = document.createElement('li');
        li.className = 'nav-item';
        li.innerHTML = `<a class="nav-link" id="nav-${key}" onclick="loadContent('teoria_${key}')">📄 ${entry.title}</a>`;
        navTeoria.appendChild(li);
    });

    // Pratica
    const praticaEntries = Object.keys(repoData.pratica).sort();
    praticaEntries.forEach(key => {
        const entry = repoData.pratica[key];
        const li = document.createElement('li');
        li.className = 'nav-item';
        li.innerHTML = `<a class="nav-link" id="nav-${key}" onclick="loadContent('pratica_${key}')">⚡ ${entry.title}</a>`;
        navPratica.appendChild(li);
    });


}

// Global Content Loader
function loadContent(contentId) {
    // Update UI State
    document.querySelectorAll('.nav-link').forEach(el => el.classList.remove('active'));
    const activeLink = document.getElementById(`nav-${contentId.replace(/^[^_]+_/, '')}`);
    if (activeLink) activeLink.classList.add('active');

    if (contentId === 'home') {
        views.home.style.display = 'block';
        views.markdown.style.display = 'none';
        window.scrollTo(0, 0);
        return;
    }

    // Parse ID
    const parts = contentId.split('_');
    const category = parts[0];
    const fileKey = parts.slice(1).join('_');

    if (repoData[category] && repoData[category][fileKey]) {
        const data = repoData[category][fileKey];

        // Switch View
        views.home.style.display = 'none';
        views.markdown.style.display = 'block';

        // Render Markdown
        markdownContent.innerHTML = marked.parse(data.content);

        // Highlight Code Blocks via Prism
        setTimeout(() => {
            Prism.highlightAllUnder(markdownContent);
        }, 50);

        window.scrollTo(0, 0);
    } else {
        console.error(`Contenuto ${contentId} non trovato.`);
    }
}

// Initial Run
window.onload = () => {
    initializeNav();
};
