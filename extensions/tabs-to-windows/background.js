browser.tabs.onCreated.addListener(async (tab) => {
  const win = await browser.windows.get(tab.windowId, {
    populate: true,
  });
  if (win.tabs.length <= 1) return;

  await browser.windows.create({ tabId: tab.id });
});
