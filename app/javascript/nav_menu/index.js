function turnWhite() {
  const thapeLogo = document.getElementById('thape-nav-logo');
  const thapeNavBar = document.getElementById('thape-nav-bar');
  const thapeNavContainer = document.getElementById('thape-nav-container');

  thapeNavBar.classList.remove("nav-background-initial");
  thapeNavBar.classList.add("nav-background-white");
  thapeNavBar.classList.add("border-gray-200");
  thapeNavBar.classList.add("border-solid");
  thapeNavBar.classList.add("border-b");
  const tc = thapeLogo.classList;
  tc.add("text-black6c");
  tc.remove("text-thape-white-t80");
  tc.add("hover:text-black6c-t70");
  tc.add("focus:text-black6c-t70");
  tc.remove("hover:text-white");
  tc.remove("focus:text-white");

  for (let a of thapeNavContainer.children) {
    const c=a.classList;
    c.add("hover:text-black6c");
    c.add("focus:text-black6c");
    c.remove("hover:text-white");
    c.remove("focus:text-white");
  }
  thapeNavContainer.classList.remove("text-thape-white-t80");
  thapeNavContainer.classList.add("text-thape-copyright-gray");
}

function turnTransparent() {
  const thapeLogo = document.getElementById('thape-nav-logo');
  const thapeNavBar = document.getElementById('thape-nav-bar');
  const thapeNavContainer = document.getElementById('thape-nav-container');

  thapeNavContainer.classList.remove("text-thape-copyright-gray");
  thapeNavContainer.classList.add("text-thape-white-t80");
  for (let a of thapeNavContainer.children) {
    const c=a.classList;
    c.remove("hover:text-black6c");
    c.remove("focus:text-black6c");
    c.add("hover:text-white");
    c.add("focus:text-white");
  }
  const tc = thapeLogo.classList;
  tc.add("text-thape-white-t80");
  tc.remove("text-black6c");
  tc.remove("hover:text-black6c-t70");
  tc.remove("focus:text-black6c-t70");
  tc.add("hover:text-white");
  tc.add("focus:text-white");
  thapeNavBar.classList.remove("nav-background-white");
  thapeNavBar.classList.remove("border-gray-200");
  thapeNavBar.classList.remove("border-solid");
  thapeNavBar.classList.remove("border-b");
  thapeNavBar.classList.add("nav-background-initial");
}

export default { turnWhite, turnTransparent };
