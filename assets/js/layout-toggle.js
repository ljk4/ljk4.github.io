(() => {
  const STORAGE_KEYS = {
    left: 'layout-toggle-left-collapsed',
    right: 'layout-toggle-right-collapsed',
  };

  const body = document.body;
  if (!body) return;

  const hasSidebar = Boolean(document.getElementById('sidebar'));
  const hasPanel = Boolean(document.getElementById('panel-wrapper'));

  if (!hasSidebar && !hasPanel) return;

  const readBool = (key) => {
    try {
      return localStorage.getItem(key) === '1';
    } catch (_error) {
      return false;
    }
  };

  const writeBool = (key, value) => {
    try {
      localStorage.setItem(key, value ? '1' : '0');
    } catch (_error) {
      // ignore
    }
  };

  const state = {
    left: readBool(STORAGE_KEYS.left),
    right: readBool(STORAGE_KEYS.right),
  };

  const controls = document.createElement('div');
  controls.className = 'layout-toggle-controls';
  controls.setAttribute('aria-label', '布局切换');

  const leftBtn = document.createElement('button');
  leftBtn.type = 'button';
  leftBtn.className = 'toggle-left';
  leftBtn.setAttribute('aria-label', '切换左栏');

  const rightBtn = document.createElement('button');
  rightBtn.type = 'button';
  rightBtn.className = 'toggle-right';
  rightBtn.setAttribute('aria-label', '切换右栏');

  const applyState = () => {
    body.classList.toggle('sidebar-collapsed-desktop', state.left);
    body.classList.toggle('panel-collapsed', state.right);

    if (hasSidebar) {
      leftBtn.textContent = state.left ? '展开左栏' : '收起左栏';
    }

    if (hasPanel) {
      rightBtn.textContent = state.right ? '展开右栏' : '收起右栏';
    }
  };

  if (hasSidebar) {
    controls.appendChild(leftBtn);
    leftBtn.addEventListener('click', () => {
      state.left = !state.left;
      writeBool(STORAGE_KEYS.left, state.left);
      applyState();
    });
  }

  if (hasPanel) {
    controls.appendChild(rightBtn);
    rightBtn.addEventListener('click', () => {
      state.right = !state.right;
      writeBool(STORAGE_KEYS.right, state.right);
      applyState();
    });
  }

  if (controls.children.length === 0) return;

  body.appendChild(controls);
  applyState();
})();
