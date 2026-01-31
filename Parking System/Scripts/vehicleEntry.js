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

    function submitEntry() {
        const ownerName = document.getElementById("ownerName")?.value.trim();
        const phoneNumber = document.getElementById("phoneNumber")?.value.trim();
        const vehicleNumber = document.getElementById("vehicleNumber")?.value.trim();
        const useSystemTime = document.getElementById("useSystemTime")?.checked;
        const resultDiv = document.getElementById("result");

        if (!ownerName || !phoneNumber || !vehicleNumber) {
            resultDiv.className = "message error";
            resultDiv.innerText = "Please fill in all fields";
            return;
        }

        let entryTime = "";
        if (!useSystemTime) {
            entryTime = document.getElementById("entryTime").value;
            if (!entryTime) {
                resultDiv.className = "message error";
                resultDiv.innerText = "Please select entry time";
                return;
            }
        }

        resultDiv.className = "message info";
        resultDiv.innerText = "Allocating slot...";

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

                    setTimeout(() => {
                        document.getElementById("ownerName").value = "";
                        document.getElementById("phoneNumber").value = "";
                        document.getElementById("vehicleNumber").value = "";
                        document.getElementById("entryTime").value = "";
                        document.getElementById("useSystemTime").checked = true;
                        toggleTimeInput();
                    }, 2000);
                } else {
                    resultDiv.className = "message error";
                    resultDiv.innerText = data.message;
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
        submitEntry
    };
})();