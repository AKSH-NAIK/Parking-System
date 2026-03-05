// Shared entry form logic
console.info("vehicleEntry.js loaded");

const VehicleEntry = (function () {
    let vehicleType = "2Wheeler";

    function normalizeType(value) {
        return (value || "").replace(/[\s-]/g, "");
    }

    function init(type) {
        vehicleType = normalizeType(type) || "2Wheeler";
        toggleTimeInput();
    }

    function toggleTimeInput() {
        const useSystem = document.getElementById("useSystemTime");
        const timeInput = document.getElementById("entryTime");
        if (!useSystem || !timeInput) return;

        timeInput.disabled = useSystem.checked;

        if (useSystem.checked) {
            timeInput.value = "";
        } else {
            const now = new Date();
            now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
            timeInput.value = now.toISOString().slice(0, 16);
        }
    }

    function printReceipt() {
        window.print();
    }

    function submitEntry() {
        const ownerName = document.getElementById("ownerName")?.value.trim();
        const phoneNumber = document.getElementById("phoneNumber")?.value.trim();
        const vehicleNumber = document.getElementById("vehicleNumber")?.value.trim().toUpperCase();
        const useSystemTime = document.getElementById("useSystemTime")?.checked;
        const resultDiv = document.getElementById("result");
        const printBtn = document.getElementById("printReceiptBtn");

        if (!ownerName || !phoneNumber || !vehicleNumber) {
            resultDiv.className = "message error";
            resultDiv.innerText = "Please fill in all fields";
            if (typeof Toast !== 'undefined') Toast.error("Missing information");
            return;
        }

        let entryTime = "";
        let displayedTime = new Date().toLocaleString();

        if (!useSystemTime) {
            entryTime = document.getElementById("entryTime").value;
            if (!entryTime) {
                resultDiv.className = "message error";
                resultDiv.innerText = "Please select entry time";
                return;
            }
            displayedTime = new Date(entryTime).toLocaleString();
        }

        resultDiv.className = "message info";
        resultDiv.innerText = "Allocating slot...";
        if (printBtn) printBtn.style.display = 'none';

        const formData = new URLSearchParams();
        formData.append("ownerName", ownerName);
        formData.append("phoneNumber", phoneNumber);
        formData.append("vehicleNumber", vehicleNumber);
        formData.append("vehicleType", vehicleType);
        formData.append("entryTime", entryTime);

        fetch("/API/vehicleEntry.ashx", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: formData
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    resultDiv.className = "message success";
                    resultDiv.innerText = data.message;
                    if (typeof Toast !== 'undefined') Toast.success("Slot allocated: " + data.slotNumber);

                    // Setup Print Template
                    document.getElementById("p_vehicleNumber").innerText = vehicleNumber;
                    document.getElementById("p_vehicleType").innerText = vehicleType;
                    document.getElementById("p_ownerName").innerText = ownerName;
                    document.getElementById("p_phoneNumber").innerText = phoneNumber;
                    document.getElementById("p_slotNumber").innerText = data.slotNumber;
                    document.getElementById("p_entryTime").innerText = displayedTime;

                    if (printBtn) printBtn.style.display = 'inline-flex';

                    // Clear form after delay
                    setTimeout(() => {
                        document.getElementById("ownerName").value = "";
                        document.getElementById("phoneNumber").value = "";
                        document.getElementById("vehicleNumber").value = "";
                        document.getElementById("entryTime").value = "";
                        document.getElementById("useSystemTime").checked = true;
                        toggleTimeInput();
                    }, 5000); // Wait longer so they can print
                } else {
                    resultDiv.className = "message error";
                    resultDiv.innerText = data.message;
                    if (typeof Toast !== 'undefined') Toast.error(data.message);
                }
            })
            .catch(() => {
                resultDiv.className = "message error";
                resultDiv.innerText = "Network error. Please try again.";
            });
    }

    return {
        init,
        toggleTimeInput,
        submitEntry,
        printReceipt
    };
})();