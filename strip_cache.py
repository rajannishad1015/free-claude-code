"""
Custom pre-call hook for LiteLLM.
Sanitizes Anthropic messages by stripping `cache_control` annotations
that causes failures on models/providers that don't support explicit context caching.
"""

from litellm.integrations.custom_logger import CustomLogger


def remove_cache_control(obj):
    if isinstance(obj, dict):
        return {
            k: remove_cache_control(v)
            for k, v in obj.items()
            if k != "cache_control"
        }
    elif isinstance(obj, list):
        return [remove_cache_control(item) for item in obj]
    return obj


class StripCacheHandler(CustomLogger):
    async def async_pre_call_hook(self, user_api_key_dict, cache, data, call_type):
        for key in ["messages", "system", "tools"]:
            if key in data and data[key] is not None:
                data[key] = remove_cache_control(data[key])
        return data


strip_cache_handler = StripCacheHandler()
