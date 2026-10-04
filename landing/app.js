/**
 * PRICE ACTION MASTER — LANDING PAGE INTERACTIVE ENGINE
 * Logic for: B3 Calculator, Interactive Chart Simulator, Hero Animation, FAQ, Tabs & Nav
 */

document.addEventListener('DOMContentLoaded', () => {
  initNavbar();
  initHeroMiniChart();
  initModuleTabs();
  initB3Calculator();
  initInteractiveSimulator();
  initFaqAccordion();
});

/* ==========================================================================
   1. NAVBAR & MOBILE DRAWER
   ========================================================================== */
function initNavbar() {
  const header = document.getElementById('main-header');
  const mobileToggle = document.getElementById('mobile-toggle');
  const mobileDrawer = document.getElementById('mobile-drawer');
  const mobileLinks = document.querySelectorAll('.mobile-link');

  // Scroll effect
  window.addEventListener('scroll', () => {
    if (window.scrollY > 40) {
      header.classList.add('scrolled');
    } else {
      header.classList.remove('scrolled');
    }
  });

  // Mobile toggle
  if (mobileToggle && mobileDrawer) {
    mobileToggle.addEventListener('click', () => {
      mobileDrawer.classList.toggle('open');
      const icon = mobileToggle.querySelector('i');
      if (mobileDrawer.classList.contains('open')) {
        icon.classList.remove('fa-bars');
        icon.classList.add('fa-xmark');
      } else {
        icon.classList.remove('fa-xmark');
        icon.classList.add('fa-bars');
      }
    });

    mobileLinks.forEach(link => {
      link.addEventListener('click', () => {
        mobileDrawer.classList.remove('open');
        const icon = mobileToggle.querySelector('i');
        icon.classList.remove('fa-xmark');
        icon.classList.add('fa-bars');
      });
    });
  }
}

/* ==========================================================================
   2. HERO PHONE MINI CANVAS CHART (LIVE ANIMATION)
   ========================================================================== */
function initHeroMiniChart() {
  const canvas = document.getElementById('hero-mini-chart');
  if (!canvas) return;
  const ctx = canvas.getContext('2d');

  // Candle data simulation
  const candles = [
    { o: 80, h: 95, l: 75, c: 90, up: true },
    { o: 90, h: 92, l: 65, c: 70, up: false },
    { o: 70, h: 78, l: 55, c: 60, up: false }, // Low OB base
    { o: 60, h: 65, l: 50, c: 55, up: false }, // Sweep candle
    { o: 55, h: 105, l: 54, c: 100, up: true }, // Impulsive expansion
    { o: 100, h: 130, l: 95, c: 125, up: true },
    { o: 125, h: 145, l: 120, c: 140, up: true }, // BOS
    { o: 140, h: 142, l: 110, c: 115, up: false }, // Pullback to OB
    { o: 115, h: 120, l: 75, c: 80, up: false }, // Tap in OB
    { o: 80, h: 140, l: 78, c: 135, up: true }, // Reversal candle
  ];

  let tickOffset = 0;
  let tickDirection = 1;

  function renderHeroChart() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Draw background grid lines
    ctx.strokeStyle = 'rgba(15, 23, 42, 0.05)';
    ctx.lineWidth = 1;
    for (let y = 30; y < canvas.height; y += 35) {
      ctx.beginPath();
      ctx.moveTo(0, y);
      ctx.lineTo(canvas.width, y);
      ctx.stroke();
    }
    for (let x = 30; x < canvas.width; x += 45) {
      ctx.beginPath();
      ctx.moveTo(x, 0);
      ctx.lineTo(x, canvas.height);
      ctx.stroke();
    }

    // Draw Order Block Zone (OB)
    ctx.fillStyle = 'rgba(14, 108, 4, 0.12)';
    ctx.strokeStyle = '#0E6C04';
    ctx.lineWidth = 1.5;
    ctx.strokeRect(60, 115, 230, 35);
    ctx.fillRect(60, 115, 230, 35);

    // Draw BOS dotted line
    ctx.strokeStyle = '#0284C7';
    ctx.setLineDash([4, 4]);
    ctx.beginPath();
    ctx.moveTo(180, 50);
    ctx.lineTo(310, 50);
    ctx.stroke();
    ctx.setLineDash([]); // reset

    // Draw Candles
    const candleWidth = 14;
    const spacing = 26;
    const startX = 25;
    const baseY = 170;

    candles.forEach((c, i) => {
      let isLast = i === candles.length - 1;
      let currentC = isLast ? c.c + tickOffset : c.c;
      let currentH = isLast ? Math.max(c.h, currentC + 3) : c.h;
      let isUp = currentC >= c.o;

      const x = startX + (i * spacing);
      const openY = baseY - c.o;
      const closeY = baseY - currentC;
      const highY = baseY - currentH;
      const lowY = baseY - c.l;

      // Wick
      ctx.strokeStyle = isUp ? '#0E6C04' : '#DD462D';
      ctx.lineWidth = 1.5;
      ctx.beginPath();
      ctx.moveTo(x + candleWidth / 2, highY);
      ctx.lineTo(x + candleWidth / 2, lowY);
      ctx.stroke();

      // Body
      ctx.fillStyle = isUp ? '#0E6C04' : '#DD462D';
      const bodyTop = Math.min(openY, closeY);
      const bodyHeight = Math.max(Math.abs(openY - closeY), 3);
      ctx.fillRect(x, bodyTop, candleWidth, bodyHeight);
    });

    // Animate the live ticking candle
    tickOffset += 0.25 * tickDirection;
    if (tickOffset > 8) tickDirection = -1;
    if (tickOffset < -4) tickDirection = 1;

    requestAnimationFrame(renderHeroChart);
  }

  renderHeroChart();
}

/* ==========================================================================
   3. MODULE SHOWCASE TABS
   ========================================================================== */
function initModuleTabs() {
  const tabButtons = document.querySelectorAll('.tab-btn');
  const tabPanes = document.querySelectorAll('.tab-pane');

  tabButtons.forEach(button => {
    button.addEventListener('click', () => {
      const targetTab = button.getAttribute('data-tab');

      // Update active button
      tabButtons.forEach(b => b.classList.remove('active'));
      button.classList.add('active');

      // Update active tab pane
      tabPanes.forEach(pane => {
        if (pane.id === `tab-${targetTab}`) {
          pane.classList.add('active');
        } else {
          pane.classList.remove('active');
        }
      });
    });
  });
}

/* ==========================================================================
   4. INTERACTIVE B3 & CRYPTO CALCULATOR ENGINE
   ========================================================================== */
function initB3Calculator() {
  // Asset specifications
  const assets = {
    WIN: {
      name: 'WIN — MINI ÍNDICE',
      rule: 'Multiplicador: R$ 0,20 por ponto • 1 tick = 5 pontos (0,2 tick/ponto)',
      pointLabel: 'Variação de Pontos (Alvo ou Stop)',
      pointStep: 5,
      pointDefault: 250,
      pointMax: 5000,
      contractDefault: 1,
      calcTicks: (pts) => pts * 0.2,
      calcResult: (contr, pts) => contr * pts * 0.2,
      formulaText: (c, p, res) => `Fórmula: ${c} contrato(s) × ${p} pontos × R$ 0,20 = ${formatBRL(res)}`
    },
    WDO: {
      name: 'WDO — MINI DÓLAR',
      rule: 'Multiplicador: R$ 10,00 por ponto • 1 tick = 0,5 ponto (2 ticks/ponto)',
      pointLabel: 'Variação em Pontos de Dólar',
      pointStep: 0.5,
      pointDefault: 10,
      pointMax: 100,
      contractDefault: 1,
      calcTicks: (pts) => pts * 2,
      calcResult: (contr, pts) => contr * pts * 10,
      formulaText: (c, p, res) => `Fórmula: ${c} contrato(s) × ${p} pontos × R$ 10,00 = ${formatBRL(res)}`
    },
    DOL: {
      name: 'DOL — DÓLAR CHEIO (Padrão 5 contratos)',
      rule: 'Multiplicador: R$ 50,00 por ponto / contrato • 1 tick = 0,5 ponto',
      pointLabel: 'Variação em Pontos de Dólar',
      pointStep: 0.5,
      pointDefault: 5,
      pointMax: 80,
      contractDefault: 5,
      calcTicks: (pts) => pts * 2,
      calcResult: (contr, pts) => contr * pts * 50,
      formulaText: (c, p, res) => `Fórmula: ${c} contrato(s) × ${p} pontos × R$ 50,00 = ${formatBRL(res)}`
    },
    IND: {
      name: 'IND — ÍNDICE CHEIO (Padrão 5 contratos)',
      rule: 'Multiplicador: R$ 1,00 por ponto / contrato • 1 tick = 5 pontos',
      pointLabel: 'Variação de Pontos do Índice',
      pointStep: 5,
      pointDefault: 250,
      pointMax: 5000,
      contractDefault: 5,
      calcTicks: (pts) => pts * 0.2,
      calcResult: (contr, pts) => contr * pts * 1.0,
      formulaText: (c, p, res) => `Fórmula: ${c} contrato(s) × ${p} pontos × R$ 1,00 = ${formatBRL(res)}`
    },
    BITFUT: {
      name: 'BITFUT — BITCOIN FUTURO B3',
      rule: 'Multiplicador: R$ 0,10 por ponto • 1 tick = 20 pontos (0,05 tick/ponto)',
      pointLabel: 'Variação de Pontos do Bitcoin',
      pointStep: 20,
      pointDefault: 500,
      pointMax: 10000,
      contractDefault: 1,
      calcTicks: (pts) => pts * 0.05,
      calcResult: (contr, pts) => contr * pts * 0.1,
      formulaText: (c, p, res) => `Fórmula: ${c} contrato(s) × ${p} pontos × R$ 0,10 = ${formatBRL(res)}`
    },
    CCM: {
      name: 'CCM — MILHO FUTURO B3 (450 sacas/contrato)',
      rule: 'Multiplicador: R$ 450,00 por ponto (R$ 1/saca) • 1 tick = 0,01 ponto (100 ticks/ponto)',
      pointLabel: 'Variação em R$ por saca',
      pointStep: 0.05,
      pointDefault: 1.50,
      pointMax: 20,
      contractDefault: 1,
      calcTicks: (pts) => pts * 100,
      calcResult: (contr, pts) => contr * pts * 450,
      formulaText: (c, p, res) => `Fórmula: ${c} contrato(s) × R$ ${p.toFixed(2)}/saca × 450 sacas = ${formatBRL(res)}`
    }
  };

  let currentAsset = 'WIN';

  // DOM Elements
  const assetButtons = document.querySelectorAll('.asset-btn');
  const displaySymbol = document.getElementById('calc-display-symbol');
  const displayRule = document.getElementById('calc-display-rule');
  const labelPoints = document.getElementById('label-points-name');

  const contractsInput = document.getElementById('calc-contracts');
  const contractsRange = document.getElementById('calc-contracts-range');
  const contractsBadge = document.getElementById('val-contracts');

  const pointsInput = document.getElementById('calc-points');
  const pointsRange = document.getElementById('calc-points-range');
  const pointsBadge = document.getElementById('val-points');

  const resTicks = document.getElementById('calc-res-ticks');
  const resFinancial = document.getElementById('calc-res-financial');
  const formulaText = document.getElementById('calc-formula-text');

  function formatBRL(value) {
    return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value);
  }

  function updateCalculator() {
    const asset = assets[currentAsset];
    const contracts = parseFloat(contractsInput.value) || 1;
    const points = parseFloat(pointsInput.value) || 0;

    // Update badges
    contractsBadge.textContent = contracts;
    pointsBadge.textContent = currentAsset === 'CCM' ? `R$ ${points.toFixed(2)}` : `${points} pts`;

    // Calculations
    const ticks = Math.round(asset.calcTicks(points));
    const resultValue = asset.calcResult(contracts, points);

    // Outputs
    resTicks.textContent = `${ticks} ticks`;
    resFinancial.textContent = formatBRL(resultValue);
    formulaText.textContent = asset.formulaText(contracts, points, resultValue);
  }

  function setAsset(assetKey) {
    currentAsset = assetKey;
    const asset = assets[assetKey];

    // Update UI headers
    displaySymbol.textContent = asset.name;
    displayRule.textContent = asset.rule;
    labelPoints.textContent = asset.pointLabel;

    // Set defaults
    contractsInput.value = asset.contractDefault;
    contractsRange.value = asset.contractDefault;

    pointsInput.value = asset.pointDefault;
    pointsInput.step = asset.pointStep;
    pointsRange.value = asset.pointDefault;
    pointsRange.step = asset.pointStep;
    pointsRange.max = asset.pointMax;

    // Button states
    assetButtons.forEach(btn => {
      if (btn.getAttribute('data-asset') === assetKey) {
        btn.classList.add('active');
      } else {
        btn.classList.remove('active');
      }
    });

    updateCalculator();
  }

  // Asset button listeners
  assetButtons.forEach(btn => {
    btn.addEventListener('click', () => {
      const assetKey = btn.getAttribute('data-asset');
      setAsset(assetKey);
    });
  });

  // Slider <-> Number input sync
  contractsRange.addEventListener('input', () => {
    contractsInput.value = contractsRange.value;
    updateCalculator();
  });
  contractsInput.addEventListener('input', () => {
    contractsRange.value = contractsInput.value;
    updateCalculator();
  });

  pointsRange.addEventListener('input', () => {
    pointsInput.value = pointsRange.value;
    updateCalculator();
  });
  pointsInput.addEventListener('input', () => {
    pointsRange.value = pointsInput.value;
    updateCalculator();
  });

  // Init
  setAsset('WIN');
}

/* ==========================================================================
   5. INTERACTIVE SIMULATOR CHALLENGE (CHART HOTSPOTS & FEEDBACK)
   ========================================================================== */
function initInteractiveSimulator() {
  const canvas = document.getElementById('interactive-challenge-canvas');
  const feedbackBox = document.getElementById('challenge-feedback');
  const hotspots = document.querySelectorAll('.chart-hotspot');

  if (!canvas) return;
  const ctx = canvas.getContext('2d');

  // Draw static chart for challenge
  function drawChallengeChart() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    // Subtle Grid
    ctx.strokeStyle = 'rgba(15, 23, 42, 0.06)';
    ctx.lineWidth = 1;
    for (let y = 40; y < canvas.height; y += 40) {
      ctx.beginPath();
      ctx.moveTo(0, y);
      ctx.lineTo(canvas.width, y);
      ctx.stroke();
    }
    for (let x = 50; x < canvas.width; x += 60) {
      ctx.beginPath();
      ctx.moveTo(x, 0);
      ctx.lineTo(x, canvas.height);
      ctx.stroke();
    }

    // Market structure lines
    ctx.strokeStyle = '#94A3B8';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(40, 220);
    ctx.lineTo(130, 120); // Top A
    ctx.lineTo(210, 180);
    ctx.lineTo(270, 250); // OB Base B (Liquidity sweep)
    ctx.lineTo(500, 70);  // High displacement (BOS)
    ctx.lineTo(620, 90);  // Top C
    ctx.stroke();

    // BOS Line
    ctx.strokeStyle = '#0284C7';
    ctx.lineWidth = 1.5;
    ctx.setLineDash([5, 5]);
    ctx.beginPath();
    ctx.moveTo(130, 120);
    ctx.lineTo(540, 120);
    ctx.stroke();
    ctx.setLineDash([]);

    ctx.fillStyle = '#0284C7';
    ctx.font = 'bold 12px "Plus Jakarta Sans", sans-serif';
    ctx.fillText('BOS (Rompimento de Estrutura)', 380, 112);

    // Draw Price action candles
    const challengeCandles = [
      { x: 50, o: 200, c: 170, h: 160, l: 210, up: true },
      { x: 80, o: 170, c: 140, h: 130, l: 175, up: true },
      { x: 110, o: 140, c: 120, h: 115, l: 145, up: true }, // Top A
      { x: 140, o: 125, c: 155, h: 120, l: 160, up: false },
      { x: 170, o: 155, c: 180, h: 150, l: 190, up: false },
      { x: 200, o: 180, c: 210, h: 175, l: 220, up: false },
      { x: 230, o: 210, c: 240, h: 205, l: 245, up: false },
      { x: 260, o: 240, c: 250, h: 235, l: 260, up: false }, // Base OB candle B
      { x: 290, o: 250, c: 190, h: 185, l: 252, up: true },  // Strong green displacement
      { x: 330, o: 190, c: 140, h: 135, l: 195, up: true },
      { x: 370, o: 140, c: 110, h: 105, l: 145, up: true },
      { x: 410, o: 110, c: 85, h: 80, l: 115, up: true },
      { x: 450, o: 85, c: 70, h: 65, l: 90, up: true },
      { x: 490, o: 70, c: 75, h: 65, l: 80, up: false },
      { x: 530, o: 75, c: 80, h: 70, l: 95, up: false },
      { x: 570, o: 80, c: 85, h: 75, l: 90, up: false },
    ];

    challengeCandles.forEach(c => {
      const isUp = c.up;
      ctx.strokeStyle = isUp ? '#0E6C04' : '#DD462D';
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.moveTo(c.x + 8, c.h);
      ctx.lineTo(c.x + 8, c.l);
      ctx.stroke();

      ctx.fillStyle = isUp ? '#0E6C04' : '#DD462D';
      const top = Math.min(c.o, c.c);
      const height = Math.max(Math.abs(c.o - c.c), 4);
      ctx.fillRect(c.x, top, 16, height);
    });
  }

  drawChallengeChart();

  // Feedback definitions
  const feedbackData = {
    a: {
      correct: false,
      title: 'Zona A — Topo Anterior Rompido (BOS)',
      desc: 'Esta região representa a máxima anterior superada pelo preço. Na teoria de SMC, a zona de Order Block de suporte se localiza na base de onde partiu o movimento de alta, e não no topo.'
    },
    b: {
      correct: true,
      title: 'Correto! Zona B — Order Block na Base do Impulso',
      desc: 'A Zona B marca as velas na base do movimento que antecederam a expansão de alta. Na análise técnica de SMC, essa é a região de suporte considerada para possíveis retestes.'
    },
    c: {
      correct: false,
      title: 'Zona C — Topo do Movimento Atual',
      desc: 'A Zona C é a máxima do impulso atual. Ela representa o término da perna de alta momentânea, não sendo uma zona de suporte ou Order Block.'
    }
  };

  hotspots.forEach(spot => {
    spot.addEventListener('click', () => {
      const choice = spot.getAttribute('data-choice');
      const data = feedbackData[choice];

      feedbackBox.style.display = 'block';
      feedbackBox.className = `challenge-feedback-box ${data.correct ? 'correct' : 'incorrect'}`;
      feedbackBox.innerHTML = `
        <h4 style="font-family: var(--font-heading); font-size: 1.1rem; font-weight: 700; color: ${data.correct ? 'var(--emerald-primary)' : 'var(--rose-accent)'}; margin-bottom: 0.4rem;">
          ${data.title}
        </h4>
        <p style="font-size: 0.95rem; color: var(--text-primary); line-height: 1.55;">
          ${data.desc}
        </p>
      `;

      // Scroll smoothly to feedback if mobile
      if (window.innerWidth < 768) {
        feedbackBox.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      }
    });
  });
}

/* ==========================================================================
   6. FAQ ACCORDION
   ========================================================================== */
function initFaqAccordion() {
  const faqItems = document.querySelectorAll('.faq-item');

  faqItems.forEach(item => {
    const questionBtn = item.querySelector('.faq-question');
    questionBtn.addEventListener('click', () => {
      const isActive = item.classList.contains('active');

      // Close all other items
      faqItems.forEach(i => i.classList.remove('active'));

      // Toggle current item
      if (!isActive) {
        item.classList.add('active');
      }
    });
  });
}
