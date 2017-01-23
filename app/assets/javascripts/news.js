// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

(function() {

$(document).on('touchend click', '.post-prev', prevArticle);
$(document).on('touchend click', '.post-next', nextArticle);

document.addEventListener('keypress', function(event) {
  if (event.charCode == 106 /* J */) {
    nextArticle();
  } else if (event.charCode == 107 /* K */) {
    prevArticle();
  }
});

document.addEventListener('turbolinks:load', function() {
  var el = document.getElementsByClassName('news-state');
  if (el.length > 0 && el[0].innerText == 'pending') {
    setTimeout(function() { Turbolinks.visit(location.toString()); }, 2000);
  }
});

function nextArticle() {
  var articles = getArticles();
  if (articles.length == 0) {
    return;
  }
  var currentArticle = getCurrentArticle(articles);
  if (currentArticle == null) {
    articles[0].scrollIntoView();
  } else {
    var nextArticle = currentArticle.nextSibling;
    while (nextArticle != null && nextArticle.tagName != 'ARTICLE') {
      nextArticle = nextArticle.nextSibling;
    }
    if (nextArticle != null) {
      nextArticle.scrollIntoView();
    }
  }
}

function prevArticle() {
  var articles = getArticles();
  if (articles.length == 0) {
    return;
  }
  var currentArticle = getCurrentArticle(articles);
  var prevArticle = null;
  if (currentArticle != null) {
    prevArticle = currentArticle.previousSibling;
    while (prevArticle != null && prevArticle.tagName != 'ARTICLE') {
      prevArticle = prevArticle.previousSibling;
    }
  }
  if (prevArticle == null) {
    document.scrollingElement.scrollTop = 0;
  } else {
    prevArticle.scrollIntoView();
  }
}

function getArticles() {
  return document.getElementsByTagName('article');
}

function getCurrentArticle(articles) {
  var scrollPos = document.scrollingElement.scrollTop + 22;
  if (articles.length == 0 || scrollPos < articles[0].offsetTop) {
    return null;
  }
  for (var i = 0; i < articles.length; i++) {
    var articleEnd = articles[i].offsetTop + articles[i].offsetHeight;
    if (scrollPos < articleEnd) {
      return articles[i];
    }
  }
  return null;
}

})();
