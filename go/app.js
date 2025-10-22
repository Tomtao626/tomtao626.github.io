'use strict';
(function () {
  const canvas = document.getElementById('board');
  const ctx = canvas.getContext('2d');
  const DPR = Math.max(1, Math.floor(window.devicePixelRatio || 1));

  const state = {
    size: 19, // intersections per side
    hover: null, // { r, c }
    selected: null, // { r, c }
  };

  function resizeCanvas() {
    const rect = canvas.getBoundingClientRect();
    canvas.width = Math.round(rect.width * DPR);
    canvas.height = Math.round(rect.height * DPR);
    ctx.setTransform(DPR, 0, 0, DPR, 0, 0); // draw in CSS pixels
    draw();
  }

  function starPoints(n) {
    if (n === 19) {
      const pts = [3, 9, 15];
      const out = [];
      for (const r of pts) {
        for (const c of pts) out.push({ r, c });
      }
      return out;
    } else if (n === 13) {
      const pts = [3, 6, 9];
      const out = [];
      for (const r of pts) {
        for (const c of pts) out.push({ r, c });
      }
      return out;
    } else if (n === 9) {
      const pts = [2, 4, 6];
      const out = [];
      for (const r of pts) {
        for (const c of pts) out.push({ r, c });
      }
      return out;
    }
    return [];
  }

  function gridMetrics() {
    const W = canvas.clientWidth;
    const H = canvas.clientHeight;
    const extent = Math.min(W, H);
    const padding = extent * 0.06;
    const gridSize = extent - 2 * padding;
    const step = gridSize / (state.size - 1);
    return { extent, padding, gridSize, step };
  }

  function draw() {
    const W = canvas.clientWidth;
    const H = canvas.clientHeight;
    ctx.clearRect(0, 0, W, H);

    // board background
    ctx.fillStyle = '#F0D9B5';
    ctx.fillRect(0, 0, W, H);

    const { padding, gridSize, step } = gridMetrics();
    const left = padding;
    const top = padding;

    ctx.strokeStyle = 'rgba(0,0,0,0.85)';
    ctx.lineWidth = Math.max(1, Math.min(2.2, W * 0.0022));
    ctx.lineCap = 'butt';

    // draw grid lines
    for (let i = 0; i < state.size; i++) {
      const x = left + i * step;
      const y = top + i * step;
      ctx.beginPath();
      ctx.moveTo(x, top);
      ctx.lineTo(x, top + gridSize);
      ctx.stroke();

      ctx.beginPath();
      ctx.moveTo(left, y);
      ctx.lineTo(left + gridSize, y);
      ctx.stroke();
    }

    // star points
    ctx.fillStyle = '#000';
    const stars = starPoints(state.size);
    for (const p of stars) {
      const x = left + p.c * step;
      const y = top + p.r * step;
      ctx.beginPath();
      ctx.arc(x, y, Math.max(1.5, W * 0.006), 0, Math.PI * 2);
      ctx.fill();
    }

    // hover preview
    if (state.hover) {
      const x = left + state.hover.c * step;
      const y = top + state.hover.r * step;
      ctx.fillStyle = 'rgba(0,0,0,0.25)';
      ctx.beginPath();
      ctx.arc(x, y, step * 0.46, 0, Math.PI * 2);
      ctx.fill();
    }

    // selection ring
    if (state.selected) {
      const x = left + state.selected.c * step;
      const y = top + state.selected.r * step;
      ctx.strokeStyle = 'rgba(244,67,54,1)';
      ctx.lineWidth = Math.max(2, W * 0.006);
      ctx.beginPath();
      ctx.arc(x, y, step * 0.48, 0, Math.PI * 2);
      ctx.stroke();
    }
  }

  function toIntersection(clientX, clientY) {
    const rect = canvas.getBoundingClientRect();
    const x = clientX - rect.left;
    const y = clientY - rect.top;

    const { extent, padding, step } = gridMetrics();
    if (x < padding || y < padding || x > extent - padding || y > extent - padding) return null;

    let c = Math.round((x - padding) / step);
    let r = Math.round((y - padding) / step);

    c = Math.max(0, Math.min(state.size - 1, c));
    r = Math.max(0, Math.min(state.size - 1, r));
    return { r, c };
  }

  canvas.addEventListener('mousemove', (e) => {
    const p = toIntersection(e.clientX, e.clientY);
    state.hover = p;
    draw();
  });

  canvas.addEventListener('mouseleave', () => {
    state.hover = null;
    draw();
  });

  canvas.addEventListener('click', (e) => {
    state.selected = toIntersection(e.clientX, e.clientY);
    draw();
  });

  window.addEventListener('resize', resizeCanvas);
  resizeCanvas();
})();
