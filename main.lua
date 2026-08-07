local avatar_topic = "TALK_BIONIC_TALISMAN_1"
local expiry_key = "arcana_technoclysm_bionic_avatar_expiry"
local avatar_lifetime = TimeDuration.from_minutes(2)

---@param npc Npc
---@return boolean
local function is_bionic_avatar(npc)
  return npc:get_first_topic() == avatar_topic
end

---@param npc Npc
local function mark_avatar(npc)
  if not is_bionic_avatar(npc) or tonumber(npc:get_value(expiry_key)) then
    return
  end
  local expiry = gapi.current_turn() + avatar_lifetime
  npc:set_value(expiry_key, tostring(expiry:to_turn()))
end

---@param npc Npc
local function expire_avatar(npc)
  local expiry = tonumber(npc:get_value(expiry_key))
  if expiry and gapi.current_turn():to_turn() >= expiry then
    npc:erase()
  end
end

---@param params OnNpcSpawnParams
local function on_npc_spawn(params)
  local npc = params.npc
  mark_avatar(npc)
end

---@class ArcanaTechnoclysmNpcTurnParams
---@field npc Npc
---@param params ArcanaTechnoclysmNpcTurnParams
local function on_npc_do_turn(params)
  mark_avatar(params.npc)
  expire_avatar(params.npc)
end

---@param params OnNpcLoadedParams
local function on_npc_loaded(params)
  mark_avatar(params.npc)
  expire_avatar(params.npc)
end

game.add_hook("on_npc_spawn", on_npc_spawn)
game.add_hook("on_npc_do_turn", on_npc_do_turn)
game.add_hook("on_npc_loaded", on_npc_loaded)
