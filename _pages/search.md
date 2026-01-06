---
layout: page
title: Search
permalink: /search
---

{% include search.html %}

<div id="search-page-container">
  <div class="search-input-wrapper">
    <input
      type="search"
      id="page-search-input"
      placeholder="Search all posts and notes..."
      aria-label="Search site content"
    />
  </div>

  <div class="search-filters">
    <button class="filter-btn active" data-filter="all">All</button>
    <button class="filter-btn" data-filter="posts">Posts</button>
    <button class="filter-btn" data-filter="notes">Notes</button>
  </div>

  <div id="search-stats" hidden>
    <span id="result-count"></span> results in <span id="search-time"></span>ms
  </div>

  <div id="page-search-results"></div>

  <button id="load-more-btn" hidden>Load More Results</button>
</div>

<script>
(function() {
  const pageSearchInput = document.getElementById('page-search-input');
  const pageSearchResults = document.getElementById('page-search-results');
  const searchStats = document.getElementById('search-stats');
  const resultCountEl = document.getElementById('result-count');
  const searchTimeEl = document.getElementById('search-time');
  const loadMoreBtn = document.getElementById('load-more-btn');
  const filterBtns = document.querySelectorAll('.filter-btn');

  let allResults = [];
  let displayedCount = 0;
  const RESULTS_PER_PAGE = 50;

  // Parse URL parameters
  const urlParams = new URLSearchParams(window.location.search);
  const initialQuery = urlParams.get('q') || '';

  // Set initial search if query param exists
  if (initialQuery) {
    pageSearchInput.value = initialQuery;
    performPageSearch(initialQuery);
  }

  // Auto-focus search input (but not on mobile to avoid keyboard popup)
  if (window.innerWidth > 700) {
    pageSearchInput.focus();
  }

  // Search on input with debouncing
  const debouncedPageSearch = debounce((query) => {
    updateURL(query);
    if (query.length < 2) {
      clearResults();
      return;
    }
    performPageSearch(query);
  }, 200);

  pageSearchInput.addEventListener('input', (e) => {
    const query = e.target.value.trim();
    debouncedPageSearch(query);
  });

  // Filter buttons
  filterBtns.forEach(btn => {
    btn.addEventListener('click', (e) => {
      // Toggle active state
      filterBtns.forEach(b => b.classList.remove('active'));
      e.target.classList.add('active');

      // Re-run search with new filter
      const query = pageSearchInput.value.trim();
      if (query.length >= 2) {
        performPageSearch(query);
      }
    });
  });

  // Load more button
  loadMoreBtn.addEventListener('click', () => {
    displayMoreResults();
  });

  // Update URL without reload
  function updateURL(query) {
    const url = new URL(window.location);
    if (query) {
      url.searchParams.set('q', query);
    } else {
      url.searchParams.delete('q');
    }
    window.history.replaceState({}, '', url);
  }

  // Perform search on page
  async function performPageSearch(query) {
    // Show loading
    pageSearchResults.innerHTML = '<div class="search-loading">Searching</div>';
    searchStats.hidden = true;
    loadMoreBtn.hidden = true;

    try {
      // Initialize search if needed
      await initializeSearch();

      const startTime = performance.now();

      // Get active filter
      const activeFilter = document.querySelector('.filter-btn.active');
      const filter = activeFilter ? activeFilter.dataset.filter : 'all';

      // Perform search
      allResults = performSearch(query, filter);

      const endTime = performance.now();

      // Show stats
      resultCountEl.textContent = allResults.length;
      searchTimeEl.textContent = Math.round(endTime - startTime);
      searchStats.hidden = false;

      // Reset and render results
      displayedCount = 0;
      pageSearchResults.innerHTML = '';
      displayMoreResults();

      // Setup keyboard navigation
      setupKeyboardNav(pageSearchInput, pageSearchResults, '.search-result-item');
    } catch (error) {
      pageSearchResults.innerHTML = '<div class="no-results">Error loading search. Please try again.</div>';
      console.error('Search error:', error);
    }
  }

  // Display more results
  function displayMoreResults() {
    const nextBatch = allResults.slice(displayedCount, displayedCount + RESULTS_PER_PAGE);

    if (nextBatch.length === 0) {
      loadMoreBtn.hidden = true;
      return;
    }

    // Render next batch
    nextBatch.forEach(result => {
      const item = result.item;
      const resultEl = document.createElement('div');
      resultEl.className = 'search-result-item';
      resultEl.dataset.url = item.url;

      // Create type badge
      const typeBadge = `<span class="search-result-type">${item.type === 'notes' ? 'NOTE' : 'POST'}</span>`;

      // Get snippet
      const snippet = getSnippet(item.content, result.matches, 200);

      // Format date
      const date = new Date(item.date);
      const dateStr = date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' });

      // Tags
      const tagsHtml = item.tags && item.tags.length > 0
        ? '<div class="search-result-tags">Tags: ' + item.tags.slice(0, 5).join(', ') + '</div>'
        : '';

      resultEl.innerHTML = `
        <div class="search-result-title">
          ${typeBadge}
          <span>${highlightMatches(item.title, result.matches, 'title')}</span>
        </div>
        <div class="search-result-snippet">${snippet}</div>
        ${tagsHtml}
        <div class="search-result-meta">${dateStr}</div>
      `;

      // Click handler
      resultEl.addEventListener('click', () => {
        window.location.href = item.url;
      });

      pageSearchResults.appendChild(resultEl);
    });

    displayedCount += nextBatch.length;

    // Show/hide load more button
    loadMoreBtn.hidden = displayedCount >= allResults.length;
  }

  // Clear results
  function clearResults() {
    pageSearchResults.innerHTML = '';
    searchStats.hidden = true;
    loadMoreBtn.hidden = true;
    allResults = [];
    displayedCount = 0;
  }
})();
</script>
