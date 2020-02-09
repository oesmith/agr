document.addEventListener('turbolinks:load', function() {
  const showLinks = document.getElementsByClassName('tweet-data-show');
  for (let i = 0; i < showLinks.length; i++) {
    showLinks[i].addEventListener('click', function(e) {
      const container = e.target.parentNode;
      container.classList.remove('tweet-data-closed');
      container.classList.add('tweet-data-open');
      e.stopPropagation();
    });
  }

  const hideLinks = document.getElementsByClassName('tweet-data-hide');
  for (let i = 0; i < hideLinks.length; i++) {
    hideLinks[i].addEventListener('click', function(e) {
      const container = e.target.parentNode;
      container.classList.remove('tweet-data-open');
      container.classList.add('tweet-data-closed');
      e.stopPropagation();
    });
  }
});


