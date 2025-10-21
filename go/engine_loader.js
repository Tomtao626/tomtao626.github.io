// Placeholder for future WASM engine loader. Must run before app bootstrap.
// Expose a namespace window.GoEngine for later interop.
(function (global) {
  global.GoEngine = global.GoEngine || {
    init: async function () { /* no-op for now */ },
  };
})(window);
