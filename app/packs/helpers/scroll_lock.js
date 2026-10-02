// Each overlay owns one lock. Only the last close restores the page.
const owners = new Map();
let saved;

const remember = (element, names) => names.map(name => [
  element, name, element.style.getPropertyValue(name), element.style.getPropertyPriority(name)
]);

export function lockScroll(owner, reset) {
  if (owners.has(owner)) return;
  if (!owners.size) {
    const body = document.body;
    const root = document.documentElement;
    const gap = window.innerWidth - root.clientWidth;
    saved = {
      x: window.scrollX,
      y: window.scrollY,
      styles: [
        ...remember(body, ["position", "top", "left", "width", "overflow", "padding-right"]),
        ...remember(root, ["overflow", "scroll-behavior"])
      ]
    };
    const padding = parseFloat(getComputedStyle(body).paddingRight) || 0;
    root.style.setProperty("scroll-behavior", "auto", "important");
    root.style.setProperty("overflow", "hidden", "important");
    body.style.setProperty("position", "fixed", "important");
    body.style.setProperty("top", `${-saved.y}px`, "important");
    body.style.setProperty("left", `${-saved.x}px`, "important");
    body.style.setProperty("width", "100%", "important");
    body.style.setProperty("overflow", "hidden", "important");
    if (gap > 0) body.style.setProperty("padding-right", `${padding + gap}px`, "important");
  }
  owners.set(owner, reset);
}

export function unlockScroll(owner) {
  if (!owners.delete(owner) || owners.size) return;
  const state = saved;
  saved = null;
  const restore = ([element, name, value, priority]) => {
    if (value) element.style.setProperty(name, value, priority);
    else element.style.removeProperty(name);
  };
  // Keep smooth scrolling disabled until the original position is restored.
  const behavior = state.styles.pop();
  state.styles.forEach(restore);
  window.scrollTo(state.x, state.y);
  restore(behavior);
}

export function lockedScrollY() {
  return saved ? saved.y : window.scrollY;
}

export function isTopScrollLock(owner) {
  return Array.from(owners.keys()).pop() === owner;
}

function resetScrollLocks() {
  Array.from(owners, ([owner, reset]) => ({owner, reset})).reverse().forEach(({owner, reset}) => {
    reset();
    unlockScroll(owner);
  });
}

// Close overlays before caching a document; BFCache must also restore an unlocked page.
["turbo:before-cache", "turbolinks:before-cache"].forEach(event => document.addEventListener(event, resetScrollLocks));
window.addEventListener("pagehide", resetScrollLocks);
