/* ============================================
   REENCONTRO MZ — App Logic
   Family Reunification PWA
   ============================================ */

// ---- Mock Data ----
const MOCK_DATA = [
  {
    id: '1',
    type: 'missing',
    name: 'Maria João Silva',
    age: 8,
    description: 'Menina de 8 anos, cabelo curto, vestido azul escolar. Última vez vista perto da Escola Primária de Chaquelane durante a subida das águas.',
    lastLocation: 'Chaquelane, Distrito de Chibuto',
    contactName: 'Ana Silva (mãe)',
    contactPhone: '+258 84 123 4567',
    timestamp: new Date(Date.now() - 3600000).toISOString(),
    status: 'active',
    urgency: 'high',
    photoUrl: 'child.jpg'
  },
  {
    id: '2',
    type: 'missing',
    name: 'Pedro Augusto Nhambe',
    age: 65,
    description: 'Homem idoso, usa bengala, camisa branca. Não consegue nadar. Visto pela última vez na zona baixa de Xai-Xai antes da evacuação.',
    lastLocation: 'Zona Baixa, Xai-Xai',
    contactName: 'José Nhambe (filho)',
    contactPhone: '+258 87 654 3210',
    timestamp: new Date(Date.now() - 7200000).toISOString(),
    status: 'active',
    urgency: 'critical',
    photoUrl: 'man.jpg'
  },
  {
    id: '3',
    type: 'found',
    name: 'Criança ~5 anos (Tito)',
    age: 5,
    description: 'Menino encontrado sozinho no Centro de Evacuação. Não sabe dizer o nome completo, diz chamar-se "Tito". Está bem de saúde, a comer e a beber normalmente.',
    lastLocation: 'Centro de Evacuação EP1 Chibuto',
    contactName: 'Voluntário Cruz Vermelha',
    contactPhone: '+258 82 000 1111',
    timestamp: new Date(Date.now() - 1800000).toISOString(),
    status: 'active',
    urgency: 'medium'
  },
  {
    id: '4',
    type: 'sos',
    name: 'Família Machava',
    age: null,
    description: 'Família de 6 pessoas presa no telhado. Água a subir. Precisamos de barco urgente! Temos 2 crianças pequenas e uma grávida de 7 meses.',
    lastLocation: 'Bairro 3 de Fevereiro, Chókwè',
    contactName: 'Carlos Machava',
    contactPhone: '+258 86 999 8888',
    timestamp: new Date(Date.now() - 900000).toISOString(),
    status: 'active',
    urgency: 'critical',
    needType: 'resgate'
  },
  {
    id: '5',
    type: 'sos',
    name: 'Centro de Saúde Guijá',
    age: null,
    description: 'Precisamos urgente de água potável e medicamentos para diarreia. 200+ pessoas no centro de evacuação, muitas crianças doentes. Stock de ORS esgotado.',
    lastLocation: 'Centro de Evacuação, Guijá',
    contactName: 'Dra. Fátima Mondlane',
    contactPhone: '+258 84 555 6666',
    timestamp: new Date(Date.now() - 5400000).toISOString(),
    status: 'active',
    urgency: 'high',
    needType: 'medicamentos'
  },
  {
    id: '6',
    type: 'reunited',
    name: 'Família Sitoe — Graça reencontrada!',
    age: 3,
    description: 'A pequena Graça Sitoe (3 anos) foi reunida com a sua mãe Teresa no Centro de Evacuação de Xai-Xai após 2 dias separadas. A avó encontrou-a através deste sistema. A mãe chorou de alegria ao abraçá-la!',
    lastLocation: 'Centro de Evacuação, Xai-Xai',
    contactName: 'Suely Buque',
    contactPhone: '+258 853386491',
    timestamp: new Date(Date.now() - 86400000).toISOString(),
    status: 'reunited',
    urgency: 'none',
    photoUrl: 'https://images.unsplash.com/photo-1543884391-7649557f9202?auto=format&fit=crop&w=300&q=80'
  },
  {
    id: '7',
    type: 'missing',
    name: 'Rosa Felicidade Tembe',
    age: 34,
    description: 'Mulher de 34 anos, vestia capulana vermelha. Saiu de casa para buscar os filhos na escola e não voltou. Os filhos estão seguros no abrigo.',
    lastLocation: 'Estrada EN1, perto de Xai-Xai',
    contactName: 'Manuel Tembe (marido)',
    contactPhone: '+258 85 222 3333',
    timestamp: new Date(Date.now() - 10800000).toISOString(),
    status: 'active',
    urgency: 'high',
    photoUrl: 'woman.jpg'
  },
  {
    id: '8',
    type: 'reunited',
    name: 'Avô Joaquim — De volta à família!',
    age: 72,
    description: 'O Sr. Joaquim Cossa, de 72 anos, foi encontrado num abrigo improvisado a 8km da sua casa. Estava desorientado mas em boa saúde. O neto localizou-o através do Reencontro MZ em menos de 6 horas!',
    lastLocation: 'Abrigo Comunitário, Bilene',
    contactName: 'Alberto Cossa (neto)',
    contactPhone: '+258 84 111 2222',
    timestamp: new Date(Date.now() - 172800000).toISOString(),
    status: 'reunited',
    urgency: 'none',
    photoUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=300&q=80'
  }
];

// ---- Mock Help Points ----
const HELP_POINTS = [
  { id: 'hp1', name: 'Escola Secundária Josina Machel', type: 'Abrigo e Comida', lat: -25.9655, lng: 32.5832 },
  { id: 'hp2', name: 'Hospital Central de Maputo', type: 'Emergência Médica', lat: -25.9782, lng: 32.5898 },
  { id: 'hp3', name: 'Centro de Evacuação Xipamanine', type: 'Abrigo', lat: -25.9453, lng: 32.5641 },
  { id: 'hp4', name: 'Cruz Vermelha - Beira', type: 'Centro de Comando', lat: -19.8436, lng: 34.8389 }
];

let leafletMap = null;
let userMarker = null;

// ---- State ----
let state = {
  items: [],
  currentFilter: 'all',
  currentScreen: 'feed',
  currentDetailId: null,
  fabOpen: false,
  searchQuery: ''
};

// ---- Initialization ----
/** Initialize the app: load data, show splash, then transition to feed */
function initApp() {
  // Load from localStorage or use mock data
  const saved = localStorage.getItem('reencontro_data_v3');
  state.items = saved ? JSON.parse(saved) : [...MOCK_DATA];
  saveData();

  // Show splash screen for 2.2s
  const splash = document.getElementById('splash-screen');
  setTimeout(() => {
    splash.classList.add('fade-out');
    setTimeout(() => {
      splash.classList.add('hidden');
      renderFeed();
      updateStats();
      
      // Initialize Swiper for Carousel
      if (document.querySelector('.mySwiper')) {
        new Swiper('.mySwiper', {
          effect: 'cards',
          grabCursor: true,
        });
      }
    }, 600);
  }, 2200);

  // Setup event listeners
  setupEventListeners();
}

/** Save data to localStorage */
function saveData() {
  localStorage.setItem('reencontro_data_v3', JSON.stringify(state.items));
}

// ---- Navigation ----
/** Navigate to a screen, hiding all others */
function navigateTo(screen) {
  state.currentScreen = screen;

  // Hide all screens
  document.querySelectorAll('.screen').forEach(s => s.classList.add('hidden'));

  // Show target screen
  const target = document.getElementById(`screen-${screen}`);
  if (target) {
    target.classList.remove('hidden');
    target.scrollTop = 0;
  }

  // Update nav
  document.querySelectorAll('.nav-item').forEach(item => {
    item.classList.toggle('active', item.dataset.screen === screen);
  });

  // Close FAB if open
  if (state.fabOpen) toggleFABMenu();

  // Scroll to top
  window.scrollTo({ top: 0, behavior: 'smooth' });

  // Render screen content
  if (screen === 'feed') {
    renderFeed();
    updateStats();
  } else if (screen === 'reunions') {
    renderReunions();
  } else if (screen === 'map') {
    setTimeout(initMap, 50); // Timeout allows CSS transition to complete so map gets correct height
  }
}

// ---- Feed Rendering ----
/** Render the carousel for missing persons */
function renderMissingCarousel() {
  const track = document.getElementById('carousel-track');
  const container = document.getElementById('missing-carousel-container');
  if (!track || !container) return;

  const missingItems = state.items.filter(i => i.type === 'missing' && i.status === 'active');
  
  // Hide if no missing items or if user is filtering specifically for non-missing
  if (missingItems.length === 0 || (state.currentFilter !== 'all' && state.currentFilter !== 'missing')) {
    container.classList.add('hidden');
    return;
  }
  
  container.classList.remove('hidden');
  track.innerHTML = missingItems.map(item => `
    <div class="swiper-slide" onclick="showDetail('${item.id}')">
      <img class="carousel-photo" src="${item.photoUrl || 'https://images.unsplash.com/photo-1531384441138-1e8d6c6e7a2b?auto=format&fit=crop&w=300&q=80'}" alt="Foto de ${escapeHtml(item.name)}" loading="lazy">
      <div class="carousel-info">
        <div class="carousel-name">${escapeHtml(item.name)}</div>
        <div class="carousel-meta">${item.age ? item.age + ' anos' : 'Idade desc.'} • ${escapeHtml(item.lastLocation.split(',')[0])}</div>
        <button class="carousel-btn" onclick="event.stopPropagation(); shareItem('${item.id}')">
          <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8"/><polyline points="16 6 12 2 8 6"/><line x1="12" x2="12" y1="2" y2="15"/></svg> Partilhar
        </button>
      </div>
    </div>
  `).join('');
}

/** Render the feed with filtered items */
function renderFeed() {
  renderMissingCarousel();

  const list = document.getElementById('feed-list');
  if (!list) return;

  let items = [...state.items];

  // Apply filter
  if (state.currentFilter !== 'all') {
    items = items.filter(item => item.type === state.currentFilter);
  }

  // Apply search
  if (state.searchQuery) {
    const q = state.searchQuery.toLowerCase();
    items = items.filter(item =>
      item.name.toLowerCase().includes(q) ||
      item.description.toLowerCase().includes(q) ||
      item.lastLocation.toLowerCase().includes(q)
    );
  }

  // Sort: SOS first (critical), then by time
  items.sort((a, b) => {
    const urgencyOrder = { critical: 0, high: 1, medium: 2, none: 3 };
    const ua = urgencyOrder[a.urgency] ?? 2;
    const ub = urgencyOrder[b.urgency] ?? 2;
    if (a.type === 'sos' && b.type !== 'sos') return -1;
    if (b.type === 'sos' && a.type !== 'sos') return 1;
    if (ua !== ub) return ua - ub;
    return new Date(b.timestamp) - new Date(a.timestamp);
  });

  if (items.length === 0) {
    list.innerHTML = `
      <div class="empty-state">
        <div class="empty-state-icon">🔍</div>
        <div class="empty-state-title">Nenhum resultado</div>
        <div class="empty-state-text">Não foram encontrados registos com estes filtros.</div>
      </div>`;
    return;
  }

  list.innerHTML = items.map((item, i) => renderCard(item, i)).join('');
}

/** Render a single card */
function renderCard(item) {
  const icons = {
    missing: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="5"/><path d="M20 21a8 8 0 0 0-16 0"/></svg>',
    found: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>',
    sos: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>',
    reunited: '<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>'
  };

  const typeLabels = {
    missing: 'Desaparecido',
    found: 'Encontrado',
    sos: 'SOS Urgente',
    reunited: 'Reunido'
  };

  const urgencyClass = item.urgency === 'critical' ? 'critical' :
    item.urgency === 'high' ? 'high' :
      item.type === 'reunited' ? 'reunited' :
        item.type === 'found' ? 'found' : 'medium';

  return `
    <article class="card card--${item.type}" onclick="showDetail('${item.id}')" id="card-${item.id}">
      <div class="card-header">
        <div class="card-avatar" ${item.photoUrl ? `style="background-image: url('${item.photoUrl}'); background-size: cover; background-position: center;"` : ''}>
          ${item.photoUrl ? '' : icons[item.type]}
        </div>
        <div class="card-info">
          <div class="card-name">${escapeHtml(item.name)}</div>
          <div class="card-meta">
            <span class="card-time">${formatTimeAgo(item.timestamp)}</span>
          </div>
        </div>
        <span class="status-badge status-badge--${urgencyClass}">
          ${typeLabels[item.type]}
        </span>
      </div>
      <div class="card-description">${escapeHtml(item.description)}</div>
      <div class="card-footer">
        <span class="card-location">📍 ${escapeHtml(item.lastLocation)}</span>
        <span class="card-contact">📞 ${escapeHtml(item.contactName?.split('(')[0]?.trim() || '')}</span>
      </div>
    </article>`;
}

// ---- Stats ----
/** Update the stats grid with current counts */
function updateStats() {
  const counts = getStats();
  const el = (id) => document.getElementById(id);
  if (el('stat-missing')) el('stat-missing').textContent = counts.missing;
  if (el('stat-found')) el('stat-found').textContent = counts.found;
  if (el('stat-sos')) el('stat-sos').textContent = counts.sos;
  if (el('stat-reunited')) el('stat-reunited').textContent = counts.reunited;

  // Update nav badge for SOS
  const sosBadge = document.getElementById('nav-badge-sos');
  if (sosBadge) {
    if (counts.sos > 0) {
      sosBadge.textContent = counts.sos;
      sosBadge.classList.remove('hidden');
    } else {
      sosBadge.classList.add('hidden');
    }
  }
}

/** Get statistics counts */
function getStats() {
  return {
    missing: state.items.filter(i => i.type === 'missing').length,
    found: state.items.filter(i => i.type === 'found').length,
    sos: state.items.filter(i => i.type === 'sos').length,
    reunited: state.items.filter(i => i.type === 'reunited').length,
    total: state.items.length
  };
}

// ---- Detail View ----
/** Show the detail screen for a specific item */
function showDetail(id) {
  const item = state.items.find(i => i.id === id);
  if (!item) return;

  state.currentDetailId = id;

  const typeLabels = { missing: 'Pessoa Desaparecida', found: 'Pessoa Encontrada', sos: 'Pedido SOS', reunited: 'Família Reunida' };
  const typeIcons = {
    missing: '<svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="8" r="5"/><path d="M20 21a8 8 0 0 0-16 0"/></svg>',
    found: '<svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>',
    sos: '<svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><path d="M12 9v4"/><path d="M12 17h.01"/></svg>',
    reunited: '<svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>'
  };
  const typeColors = { missing: 'missing', found: 'found', sos: 'sos', reunited: 'reunited' };

  const screen = document.getElementById('screen-detail');
  screen.innerHTML = `
    <div class="detail-screen">
      <button class="detail-back" onclick="navigateTo('${state.currentScreen === 'detail' ? 'feed' : state.currentScreen}')" id="btn-detail-back">
        ← Voltar
      </button>

      <div class="detail-type-banner detail-type-banner--${typeColors[item.type]}">
        <span class="detail-type-icon" style="display:flex;align-items:center;justify-content:center; overflow:hidden;">
          ${item.photoUrl ? `<img src="${item.photoUrl}" style="width:100%; height:100%; object-fit:cover;">` : typeIcons[item.type]}
        </span>
        <div>
          <div class="detail-type-label" style="color: var(--color-${typeColors[item.type]}-light)">${typeLabels[item.type]}</div>
          <div class="text-xs text-muted">${formatTimeAgo(item.timestamp)}</div>
        </div>
      </div>

      <h1 class="detail-name">${escapeHtml(item.name)}</h1>

      <div class="detail-section">
        <h2 class="detail-section-title">Descrição</h2>
        <p class="detail-text">${escapeHtml(item.description)}</p>
      </div>

      <div class="detail-section">
        <h2 class="detail-section-title">Informações</h2>
        <div class="detail-info-grid">
          ${item.age ? `
          <div class="detail-info-item">
            <span class="detail-info-icon">🎂</span>
            <div>
              <div class="detail-info-label">Idade</div>
              <div class="detail-info-value">${item.age} anos</div>
            </div>
          </div>` : ''}
          <div class="detail-info-item">
            <span class="detail-info-icon">📍</span>
            <div>
              <div class="detail-info-label">Localização</div>
              <div class="detail-info-value">${escapeHtml(item.lastLocation)}</div>
            </div>
          </div>
          <div class="detail-info-item">
            <span class="detail-info-icon">👤</span>
            <div>
              <div class="detail-info-label">Contacto</div>
              <div class="detail-info-value">${escapeHtml(item.contactName)}</div>
            </div>
          </div>
          <div class="detail-info-item">
            <span class="detail-info-icon">📞</span>
            <div>
              <div class="detail-info-label">Telefone</div>
              <div class="detail-info-value">${escapeHtml(item.contactPhone)}</div>
            </div>
          </div>
          ${item.needType ? `
          <div class="detail-info-item">
            <span class="detail-info-icon">🏥</span>
            <div>
              <div class="detail-info-label">Tipo de ajuda</div>
              <div class="detail-info-value" style="text-transform: capitalize">${escapeHtml(item.needType)}</div>
            </div>
          </div>` : ''}
        </div>
      </div>

      <div class="detail-actions">
        <a href="tel:${item.contactPhone.replace(/\s/g, '')}" class="btn btn--primary btn--lg flex-1" id="btn-call-contact">
          📞 Ligar
        </a>
        <button class="btn btn--secondary btn--lg flex-1" onclick="shareItem('${item.id}')" id="btn-share">
          📤 Partilhar
        </button>
      </div>
    </div>`;

  // Show detail screen
  document.querySelectorAll('.screen').forEach(s => s.classList.add('hidden'));
  screen.classList.remove('hidden');
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

// ---- Form Submissions ----
/** Submit a missing person report */
function submitMissing(e) {
  e.preventDefault();
  const form = e.target;

  const name = form.querySelector('#missing-name').value.trim();
  const age = form.querySelector('#missing-age').value.trim();
  const location = form.querySelector('#missing-location').value.trim();
  const description = form.querySelector('#missing-description').value.trim();
  const contact = form.querySelector('#missing-contact').value.trim();
  const phone = form.querySelector('#missing-phone').value.trim();

  // Validation
  let valid = true;
  if (!name) { setError('missing-name'); valid = false; } else { clearError('missing-name'); }
  if (!location) { setError('missing-location'); valid = false; } else { clearError('missing-location'); }
  if (!description) { setError('missing-description'); valid = false; } else { clearError('missing-description'); }
  if (!contact) { setError('missing-contact'); valid = false; } else { clearError('missing-contact'); }
  if (!phone) { setError('missing-phone'); valid = false; } else { clearError('missing-phone'); }

  if (!valid) return;

  const newItem = {
    id: Date.now().toString(),
    type: 'missing',
    name,
    age: age ? parseInt(age) : null,
    description,
    lastLocation: location,
    contactName: contact,
    contactPhone: phone,
    timestamp: new Date().toISOString(),
    status: 'active',
    urgency: age && (parseInt(age) < 12 || parseInt(age) > 60) ? 'critical' : 'high'
  };

  state.items.unshift(newItem);
  saveData();
  form.reset();
  showToast('Registo publicado', `${name} foi registado como desaparecido. A comunidade será alertada.`, 'success');
  navigateTo('feed');
}

/** Submit a found person report */
function submitFound(e) {
  e.preventDefault();
  const form = e.target;

  const name = form.querySelector('#found-name').value.trim();
  const age = form.querySelector('#found-age').value.trim();
  const location = form.querySelector('#found-location').value.trim();
  const description = form.querySelector('#found-description').value.trim();
  const contact = form.querySelector('#found-contact').value.trim();
  const phone = form.querySelector('#found-phone').value.trim();

  let valid = true;
  if (!name) { setError('found-name'); valid = false; } else { clearError('found-name'); }
  if (!location) { setError('found-location'); valid = false; } else { clearError('found-location'); }
  if (!description) { setError('found-description'); valid = false; } else { clearError('found-description'); }
  if (!contact) { setError('found-contact'); valid = false; } else { clearError('found-contact'); }
  if (!phone) { setError('found-phone'); valid = false; } else { clearError('found-phone'); }

  if (!valid) return;

  const newItem = {
    id: Date.now().toString(),
    type: 'found',
    name,
    age: age ? parseInt(age) : null,
    description,
    lastLocation: location,
    contactName: contact,
    contactPhone: phone,
    timestamp: new Date().toISOString(),
    status: 'active',
    urgency: 'medium'
  };

  state.items.unshift(newItem);
  saveData();
  form.reset();
  showToast('Pessoa reportada', `${name} foi registado como encontrado.`, 'success');
  navigateTo('feed');

  // Simulate match after 3 seconds
  setTimeout(() => simulateMatch(newItem), 3500);
}

/** Submit an SOS request */
function submitSOS(e) {
  e.preventDefault();
  const form = e.target;

  const name = form.querySelector('#sos-name').value.trim();
  const location = form.querySelector('#sos-location').value.trim();
  const needType = form.querySelector('#sos-need').value;
  const description = form.querySelector('#sos-description').value.trim();
  const contact = form.querySelector('#sos-contact').value.trim();
  const phone = form.querySelector('#sos-phone').value.trim();

  let valid = true;
  if (!name) { setError('sos-name'); valid = false; } else { clearError('sos-name'); }
  if (!location) { setError('sos-location'); valid = false; } else { clearError('sos-location'); }
  if (!description) { setError('sos-description'); valid = false; } else { clearError('sos-description'); }
  if (!phone) { setError('sos-phone'); valid = false; } else { clearError('sos-phone'); }

  if (!valid) return;

  const newItem = {
    id: Date.now().toString(),
    type: 'sos',
    name,
    age: null,
    description,
    lastLocation: location,
    contactName: contact || name,
    contactPhone: phone,
    timestamp: new Date().toISOString(),
    status: 'active',
    urgency: 'critical',
    needType
  };

  state.items.unshift(newItem);
  saveData();
  form.reset();
  showToast('SOS enviado!', 'O seu pedido de socorro foi publicado. Voluntários serão notificados.', 'success');
  navigateTo('feed');
}

// ---- Match Simulation ----
/** Simulate a match between a found person and a missing person */
function simulateMatch(foundItem) {
  // Find a random missing person to "match" with
  const missingItems = state.items.filter(i => i.type === 'missing' && i.status === 'active');
  if (missingItems.length === 0) return;

  const matched = missingItems[0]; // Match with the first one for demo

  showToast(
    '🎉 Possível correspondência!',
    `"${foundItem.name}" pode corresponder a "${matched.name}" — verifique os detalhes!`,
    'match'
  );
}

// ---- Reunions Screen ----
/** Render the reunions screen */
function renderReunions() {
  const list = document.getElementById('reunions-list');
  if (!list) return;

  const reunited = state.items.filter(i => i.type === 'reunited');
  const reunitedIcon = '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>';

  if (reunited.length === 0) {
    list.innerHTML = `
      <div class="empty-state">
        <div class="empty-state-icon" style="color: var(--color-reunited)">${reunitedIcon}</div>
        <div class="empty-state-title">Ainda sem reuniões</div>
        <div class="empty-state-text">Quando famílias forem reunidas, as suas histórias aparecerão aqui.</div>
      </div>`;
    return;
  }

  list.innerHTML = reunited.map(item => `
    <article class="reunion-card" onclick="showDetail('${item.id}')">
      <div class="card-header">
        <div class="card-avatar" style="${item.photoUrl ? `background-image: url('${item.photoUrl}'); background-size: cover; background-position: center; border: 2px solid var(--color-reunited);` : `background: var(--color-reunited-bg); border: 2px solid rgba(147,51,234,0.3); color: var(--color-reunited);`}">
          ${item.photoUrl ? '' : reunitedIcon}
        </div>
        <div class="card-info">
          <div class="card-name">${escapeHtml(item.name)}</div>
          <div class="card-meta">
            <span class="card-time">${formatTimeAgo(item.timestamp)}</span>
          </div>
        </div>
      </div>
      <div class="card-description" style="-webkit-line-clamp: 5;">${escapeHtml(item.description)}</div>
      <div class="card-footer mt-md">
        <span class="card-location">📍 ${escapeHtml(item.lastLocation)}</span>
        <span class="status-badge status-badge--reunited">✨ Reunida</span>
      </div>
    </article>`).join('');
}

// ---- FAB Menu ----
/** Toggle the floating action button menu */
function toggleFABMenu() {
  state.fabOpen = !state.fabOpen;
  const fabMain = document.getElementById('fab-main');
  const fabOptions = document.getElementById('fab-options');
  const fabBackdrop = document.getElementById('fab-backdrop');

  if (fabMain) fabMain.classList.toggle('active', state.fabOpen);
  if (fabOptions) fabOptions.classList.toggle('show', state.fabOpen);
  if (fabBackdrop) fabBackdrop.classList.toggle('show', state.fabOpen);
}

// ---- Map & Geolocation ----
/** Initialize the Leaflet map */
function initMap() {
  if (leafletMap) {
    leafletMap.invalidateSize();
    return;
  }
  
  const mapView = document.getElementById('map-view');
  if (!mapView) return;

  // Default center: Maputo
  leafletMap = L.map('map-view', { zoomControl: false }).setView([-25.9692, 32.5732], 13);
  L.control.zoom({ position: 'topright' }).addTo(leafletMap);

  L.tileLayer('https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png', {
    attribution: '&copy; OpenStreetMap &copy; CARTO'
  }).addTo(leafletMap);

  // Add help points markers
  HELP_POINTS.forEach(hp => {
    const marker = L.marker([hp.lat, hp.lng]).addTo(leafletMap);
    marker.bindPopup(`<div style="font-family:'Inter',sans-serif; text-align:center;">
      <strong style="font-size:16px;">${hp.name}</strong><br>
      <span style="color:#2188ff; font-weight:600;">${hp.type}</span>
    </div>`);
  });
}

/** Find user location and center map */
function findMe() {
  if (!leafletMap) return;
  
  showToast('A localizar...', 'A procurar a sua localização via GPS', 'info');
  
  if (!navigator.geolocation) {
    showToast('Erro', 'Geolocalização não suportada neste dispositivo', 'error');
    return;
  }

  navigator.geolocation.getCurrentPosition(
    (pos) => {
      const lat = pos.coords.latitude;
      const lng = pos.coords.longitude;
      
      if (userMarker) leafletMap.removeLayer(userMarker);
      
      const userIcon = L.divIcon({
        className: 'custom-user-marker',
        html: '<div style="background:#ef4444; width:16px; height:16px; border-radius:50%; border:3px solid white; box-shadow:0 0 10px rgba(0,0,0,0.5);"></div>',
        iconSize: [22, 22],
        iconAnchor: [11, 11]
      });
      
      userMarker = L.marker([lat, lng], {icon: userIcon}).addTo(leafletMap);
      userMarker.bindPopup('<strong style="font-family:\'Inter\'">Você está aqui</strong>').openPopup();
      
      leafletMap.flyTo([lat, lng], 14, { animate: true, duration: 1.5 });
      showToast('Localizado', 'O mapa foi centrado na sua posição', 'success');
    },
    (err) => {
      showToast('Erro GPS', 'Ative a localização para ver pontos perto de si', 'error');
    },
    { enableHighAccuracy: true, timeout: 5000, maximumAge: 0 }
  );
}

// ---- Search ----
/** Handle search input */
function handleSearch(query) {
  state.searchQuery = query;
  renderFeed();
}

// ---- Filter Chips ----
/** Handle filter chip selection */
function setFilter(filter) {
  state.currentFilter = filter;

  document.querySelectorAll('.chip').forEach(chip => {
    chip.classList.toggle('active', chip.dataset.filter === filter);
  });

  renderFeed();
}

// ---- Toast Notifications ----
/** Show a toast notification */
function showToast(title, message, type = 'success') {
  const container = document.getElementById('toast-container');
  if (!container) return;

  const icons = { success: '✅', error: '❌', match: '💜', info: 'ℹ️' };

  const toast = document.createElement('div');
  toast.className = `toast toast--${type}`;
  toast.innerHTML = `
    <span class="toast-icon">${icons[type] || '✅'}</span>
    <div class="toast-content">
      <div class="toast-title">${title}</div>
      <div class="toast-message">${message}</div>
    </div>
    <button class="toast-close" onclick="this.parentElement.remove()">✕</button>`;

  container.appendChild(toast);

  // Auto-remove after 5s
  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateY(-20px)';
    toast.style.transition = 'all 0.3s ease';
    setTimeout(() => toast.remove(), 300);
  }, 5000);
}

// ---- Form Helpers ----
/** Set error state on a form field */
function setError(fieldId) {
  const field = document.getElementById(fieldId);
  if (field) field.closest('.form-group')?.classList.add('error');
}

/** Clear error state on a form field */
function clearError(fieldId) {
  const field = document.getElementById(fieldId);
  if (field) field.closest('.form-group')?.classList.remove('error');
}

// ---- Time Formatting ----
/** Format a timestamp as "há X minutos/horas" in Portuguese */
function formatTimeAgo(timestamp) {
  const now = new Date();
  const then = new Date(timestamp);
  const diffMs = now - then;
  const diffMin = Math.floor(diffMs / 60000);
  const diffHours = Math.floor(diffMs / 3600000);
  const diffDays = Math.floor(diffMs / 86400000);

  if (diffMin < 1) return 'Agora mesmo';
  if (diffMin < 60) return `há ${diffMin} min`;
  if (diffHours < 24) return `há ${diffHours}h`;
  if (diffDays === 1) return 'Ontem';
  return `há ${diffDays} dias`;
}

// ---- Share ----
/** Share an item using Web Share API or clipboard */
function shareItem(id) {
  const item = state.items.find(i => i.id === id);
  if (!item) return;

  const typeLabels = { missing: '🚨 DESAPARECIDO', found: '✅ ENCONTRADO', sos: '🆘 SOS URGENTE', reunited: '💜 REUNIDO' };
  
  // Format text to combat misinformation by always pointing to a single source of truth
  const text = `${typeLabels[item.type]} — REENCONTRO MZ\n\n` +
    `👤 Nome: ${item.name}\n` +
    `📍 Local: ${item.lastLocation}\n` +
    `📝 Info: ${item.description}\n\n` +
    `📞 Contacto: ${item.contactName} — ${item.contactPhone}\n\n` +
    `⚠️ A partilha de informações falsas no WhatsApp prejudica os resgates.\n` +
    `🔗 Verifique o status atualizado e oficial aqui: https://reencontro-mz.vercel.app/info/${item.id}`;

  if (navigator.share && /mobile/i.test(navigator.userAgent)) {
    // Use native share on mobile devices
    navigator.share({ title: `Reencontro MZ — ${item.name}`, text }).catch(() => { });
  } else {
    // Direct WhatsApp fallback for desktop/devices without Web Share
    const encodedText = encodeURIComponent(text);
    window.open(`https://wa.me/?text=${encodedText}`, '_blank');
    showToast('A redirecionar...', 'A abrir o WhatsApp com a mensagem formatada.', 'success');
  }
}

// ---- Utilities ----
/** Escape HTML to prevent XSS */
function escapeHtml(str) {
  if (!str) return '';
  const div = document.createElement('div');
  div.textContent = str;
  return div.innerHTML;
}

// ---- Event Listeners ----
/** Setup all event listeners */
function setupEventListeners() {
  // Navigation tabs
  document.querySelectorAll('.nav-item').forEach(item => {
    item.addEventListener('click', () => navigateTo(item.dataset.screen));
  });

  // Search bar
  const searchInput = document.getElementById('search-input');
  if (searchInput) {
    let debounce;
    searchInput.addEventListener('input', (e) => {
      clearTimeout(debounce);
      debounce = setTimeout(() => handleSearch(e.target.value), 200);
    });
  }

  // Filter chips
  document.querySelectorAll('.chip').forEach(chip => {
    chip.addEventListener('click', () => setFilter(chip.dataset.filter));
  });

  // FAB
  const fabMain = document.getElementById('fab-main');
  if (fabMain) fabMain.addEventListener('click', toggleFABMenu);

  const fabBackdrop = document.getElementById('fab-backdrop');
  if (fabBackdrop) fabBackdrop.addEventListener('click', toggleFABMenu);

  // FAB options
  document.getElementById('fab-opt-missing')?.addEventListener('click', () => {
    toggleFABMenu();
    navigateTo('form-missing');
  });
  document.getElementById('fab-opt-found')?.addEventListener('click', () => {
    toggleFABMenu();
    navigateTo('form-found');
  });
  document.getElementById('fab-opt-sos')?.addEventListener('click', () => {
    toggleFABMenu();
    navigateTo('form-sos');
  });

  // Forms
  document.getElementById('form-missing')?.addEventListener('submit', submitMissing);
  document.getElementById('form-found')?.addEventListener('submit', submitFound);
  document.getElementById('form-sos')?.addEventListener('submit', submitSOS);

  // Form back buttons
  document.querySelectorAll('.form-back-btn').forEach(btn => {
    btn.addEventListener('click', () => navigateTo('feed'));
  });

  // Clear errors on input
  document.querySelectorAll('.form-input, .form-textarea, .form-select').forEach(input => {
    input.addEventListener('input', () => clearError(input.id));
  });

  // Map GPS button
  const btnGps = document.getElementById('btn-gps');
  if (btnGps) btnGps.addEventListener('click', findMe);
}

// ---- Start ----
document.addEventListener('DOMContentLoaded', initApp);
