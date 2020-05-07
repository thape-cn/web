function turnNavBarTo(bar_style) {
  const thapeNavBar = document.getElementById('thape-nav-bar');

  if (bar_style == 'white') {
    thapeNavBar.classList.remove("nav-background-initial");
    thapeNavBar.classList.add("nav-background-white");
    for (let a of thapeNavBar.children) {
      const c=a.classList;
      c.add("border-gray-200");
      c.add("border-solid");
      c.add("border-b");
    }
  } else if (bar_style == 'transparent') {
    for (let a of thapeNavBar.children) {
      const c=a.classList;
      c.remove("border-gray-200");
      c.remove("border-solid");
      c.remove("border-b");
    }

    thapeNavBar.classList.remove("nav-background-white");
    thapeNavBar.classList.add("nav-background-initial");
  }
}

function turnLogoTo(logo_style) {
  const thapeLogo = document.getElementById('thape-nav-logo');
  const tc = thapeLogo.classList;

  if (logo_style == 'white') {
    tc.add("text-black6c");
    tc.remove("text-thape-white-t80");
    tc.add("hover:text-black6c-t70");
    tc.add("focus:text-black6c-t70");
    tc.remove("hover:text-white");
    tc.remove("focus:text-white");
  } else if (logo_style == 'transparent') {
    tc.add("text-thape-white-t80");
    tc.remove("text-black6c");
    tc.remove("hover:text-black6c-t70");
    tc.remove("focus:text-black6c-t70");
    tc.add("hover:text-white");
    tc.add("focus:text-white");
  }
}

function turnNavContainer(container_id, container_style) {
  const thapeNavContainer = document.getElementById(container_id);

  if (container_style == 'white') {
    for (let a of thapeNavContainer.children) {
      const c=a.classList;
      c.add("hover:text-black6c");
      c.add("focus:text-black6c");
      c.remove("hover:text-white");
      c.remove("focus:text-white");
    }
    thapeNavContainer.classList.remove("text-thape-white-t80");
    thapeNavContainer.classList.add("text-thape-copyright-gray");
  } else if (container_style == 'transparent') {
    thapeNavContainer.classList.remove("text-thape-copyright-gray");
    thapeNavContainer.classList.add("text-thape-white-t80");
    for (let a of thapeNavContainer.children) {
      const c=a.classList;
      c.remove("hover:text-black6c");
      c.remove("focus:text-black6c");
      c.add("hover:text-white");
      c.add("focus:text-white");
    }
  }
}

function turnWhite() {
  turnNavBarTo('white');
  turnLogoTo('white');
  turnNavContainer('thape-nav-container','white');
  turnNavContainer('thape-services-container','white');
}

function turnTransparent() {
  turnNavContainer('thape-services-container','transparent');
  turnNavContainer('thape-nav-container','transparent');
  turnLogoTo('transparent');
  turnNavBarTo('transparent');
}

export default { turnWhite, turnTransparent };
