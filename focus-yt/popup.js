// Initialize button with user's preferred color
chrome.storage.sync.get("enabled", ({ enabled }) => {
  document.getElementById("enabled-checkbox").checked = enabled;
});

const checkbox = document.getElementById('enabled-checkbox');

checkbox.addEventListener('change', (event) => {
    chrome.storage.sync.set({"enabled": event.currentTarget.checked});
});