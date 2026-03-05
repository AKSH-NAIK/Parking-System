// notifications.js - Global Toast Notification System
(function () {
    const containerId = 'toast-container';

    function ensureContainer() {
        let container = document.getElementById(containerId);
        if (!container) {
            container = document.createElement('div');
            container.id = containerId;
            document.body.appendChild(container);
        }
        return container;
    }

    window.Toast = {
        show: function (message, type = 'info', duration = 4000) {
            const container = ensureContainer();
            const toast = document.createElement('div');
            toast.className = `toast ${type}`;

            let icon = 'info-circle';
            if (type === 'success') icon = 'check-circle';
            if (type === 'error') icon = 'exclamation-circle';
            if (type === 'warning') icon = 'exclamation-triangle';

            toast.innerHTML = `
                <i class="fas fa-${icon}"></i>
                <div class="toast-content">${message}</div>
            `;

            toast.onclick = () => this.hide(toast);
            container.appendChild(toast);

            if (duration > 0) {
                setTimeout(() => this.hide(toast), duration);
            }
        },

        success: function (msg, dur) { this.show(msg, 'success', dur); },
        error: function (msg, dur) { this.show(msg, 'error', dur); },
        warning: function (msg, dur) { this.show(msg, 'warning', dur); },
        info: function (msg, dur) { this.show(msg, 'info', dur); },

        hide: function (toast) {
            if (toast.classList.contains('hiding')) return;
            toast.classList.add('hiding');
            setTimeout(() => {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            }, 300);
        }
    };
})();
