browser.tabs.onCreated.addListener(async (tab) => {
  const win = await browser.windows.get(tab.windowId);
  if (win.tabs && win.tabs.length <= 1) return;

  const tabCount = (await browser.tabs.query({
    windowId: tab.windowId,
  })).length;
  if (tabCount <= 1) return;

  await browser.windows.create({ tabId: tab.id });
});
