(() => {
  const slides = Array.from(document.querySelectorAll(".slide-shell"));
  const position = document.querySelector(".slide-position");
  let current = 0;

  if (!slides.length) return;

  const clamp = (value) => Math.max(0, Math.min(slides.length - 1, value));

  function updateSlide(next, updateHash = true) {
    current = clamp(next);
    slides.forEach((slide, index) => {
      const active = index === current;
      slide.classList.toggle("is-active", active);
      slide.setAttribute("aria-hidden", active ? "false" : "true");
    });
    if (position) position.textContent = `${current + 1} / ${slides.length}`;
    document.title = `${current + 1} / ${slides.length} - ${document.querySelector("main").getAttribute("aria-label")}`;
    if (updateHash && document.body.dataset.view === "slides") {
      history.replaceState(null, "", `#/${current + 1}`);
    }
  }

  function setView(view) {
    document.body.dataset.view = view;
    if (view === "slides") {
      updateSlide(current);
    } else {
      slides.forEach((slide) => slide.removeAttribute("aria-hidden"));
      history.replaceState(null, "", location.pathname + location.search);
      document.title = `${document.querySelector("main").getAttribute("aria-label")} | Jethro Jones`;
    }
  }

  function enterFromHash() {
    const match = location.hash.match(/^#\/(\d+)$/);
    if (match) {
      current = clamp(Number(match[1]) - 1);
      setView("slides");
    } else {
      updateSlide(0, false);
      setView("handout");
    }
  }

  document.addEventListener("click", (event) => {
    const control = event.target.closest("[data-action]");
    if (!control) return;
    const action = control.dataset.action;
    if (action === "slides") setView("slides");
    if (action === "handout") setView("handout");
    if (action === "previous") updateSlide(current - 1);
    if (action === "next") updateSlide(current + 1);
    if (action === "fullscreen") {
      if (document.fullscreenElement) document.exitFullscreen();
      else document.documentElement.requestFullscreen?.();
    }
  });

  document.addEventListener("keydown", (event) => {
    if (document.body.dataset.view !== "slides") return;
    if (["ArrowRight", "ArrowDown", "PageDown", " "].includes(event.key)) {
      event.preventDefault();
      updateSlide(current + 1);
    }
    if (["ArrowLeft", "ArrowUp", "PageUp"].includes(event.key)) {
      event.preventDefault();
      updateSlide(current - 1);
    }
    if (event.key === "Home") updateSlide(0);
    if (event.key === "End") updateSlide(slides.length - 1);
    if (event.key === "Escape") setView("handout");
    if (event.key.toLowerCase() === "f") {
      if (document.fullscreenElement) document.exitFullscreen();
      else document.documentElement.requestFullscreen?.();
    }
  });

  window.addEventListener("hashchange", () => {
    const match = location.hash.match(/^#\/(\d+)$/);
    if (match) updateSlide(Number(match[1]) - 1, false);
  });

  enterFromHash();
})();

// Created by Codex GPT-5.5 on 2026-07-20 12:07 PT on Jethro-MBP
