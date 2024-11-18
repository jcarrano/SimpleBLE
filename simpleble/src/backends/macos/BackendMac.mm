#include "../common/BackendBase.h"
#include "CommonUtils.h"

#include "AdapterMac.h"

namespace SimpleBLE {

// There is no need to make this class a singleton, as there is no state (no
// member variables)
class BackendMac : public BackendBase {
  public:
    BackendMac() = default;
    virtual ~BackendMac() = default;

    virtual std::vector<std::shared_ptr<AdapterBase>> get_adapters() override;
    virtual bool bluetooth_enabled() override;
    virtual std::string backend_name() const noexcept override;
};

std::shared_ptr<BackendBase> BACKEND_MACOS() { return std::make_shared<BackendMac>(); }

vec_of_shared<AdapterBase> BackendMac::get_adapters() {
    // There doesn't seem to be a mechanism with Apple devices that openly
    // exposes more than the default Bluetooth device.
    // For this reason, the MacOS implementation of SimpleBLE will only
    // consider that single case, at least until better alternatives come up.

    vec_of_shared<AdapterBase> adapter_list;
    adapter_list.push_back(std::make_shared<AdapterMac>());
    return adapter_list;
}

bool BackendMac::bluetooth_enabled() {
    // Because CBCentralManager requires an instance of an object to properly operate,
    // we'll fabricate a local AdapterBase object and query it's internal AdapterBaseMacOS
    // to see if Bluetooth is enabled.
    // TODO: Find a better alternative for this.
    AdapterMac adapter;
    return adapter.bluetooth_enabled();
}

std::string BackendMac::backend_name() const noexcept { return "MacOS"; }

}  // namespace SimpleBLE