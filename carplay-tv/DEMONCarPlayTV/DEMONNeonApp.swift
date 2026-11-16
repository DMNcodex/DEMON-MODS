import SwiftUI
import AVKit
import WebKit

@main
struct DEMONNeonApp: App {
    var body: some Scene { WindowGroup { DemonHomeView() } }
}

private enum Neon {
    static let green = Color(red: 0.55, green: 1.0, blue: 0.12)
    static let bg = Color(red: 0.025, green: 0.04, blue: 0.035)
}

struct DemonHomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Neon.bg.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        HStack(spacing: 12) {
                            Image(systemName: "theatermasks.fill")
                                .font(.system(size: 34)).foregroundStyle(Neon.green)
                            VStack(alignment: .leading) {
                                Text("DEMON").font(.system(size: 31, weight: .black))
                                Text("CARPLAY TV").font(.caption.weight(.bold))
                                    .tracking(3).foregroundStyle(Neon.green)
                            }
                        }.padding(.top, 24)
                        Text("Entertainment Hub").foregroundStyle(.secondary)
                        NavigationLink { DemonYouTubeView() } label: {
                            DemonTile(title: "YouTube", subtitle: "Watch on iPhone", symbol: "tv")
                        }
                        NavigationLink { DemonIPTVView() } label: {
                            DemonTile(title: "IPTV", subtitle: "M3U and Xtream Codes", symbol: "dot.radiowaves.left.and.right")
                        }
                        NavigationLink { DemonSharingView() } label: {
                            DemonTile(title: "Share Screen", subtitle: "AirPlay compatible devices", symbol: "rectangle.on.rectangle")
                        }
                        Text("CarPlay does not provide unrestricted iPhone screen mirroring. Use supported receivers and watch video only while parked.")
                            .font(.footnote).foregroundStyle(.secondary)
                            .padding(.top, 8)
                    }.padding(22)
                }
            }.foregroundStyle(.white)
        }.tint(Neon.green)
    }
}

struct DemonTile: View {
    let title: String
    let subtitle: String
    let symbol: String
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: symbol).font(.title2).foregroundStyle(Neon.green)
                .frame(width: 42, height: 42)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline).foregroundStyle(.white)
                Text(subtitle).font(.caption).foregroundStyle(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(Neon.green)
        }
        .padding(18)
        .background(.white.opacity(0.055), in: RoundedRectangle(cornerRadius: 19))
        .overlay(RoundedRectangle(cornerRadius: 19).stroke(Neon.green.opacity(0.22)))
    }
}

struct DemonYouTubeView: View {
    var body: some View {
        DemonWebView(url: URL(string: "https://m.youtube.com")!)
            .navigationTitle("YouTube")
            .navigationBarTitleDisplayMode(.inline)
    }
}
struct DemonWebView: UIViewRepresentable {
    let url: URL
    func makeUIView(context: Context) -> WKWebView {
        let web = WKWebView()
        web.allowsBackForwardNavigationGestures = true
        web.load(URLRequest(url: url))
        return web
    }
    func updateUIView(_ web: WKWebView, context: Context) {}
}
struct DemonSharingView: View {
    var body: some View {
        ZStack {
            Neon.bg.ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "airplayvideo").font(.system(size: 65))
                    .foregroundStyle(Neon.green)
                Text("Screen Sharing").font(.title.bold())
                Text("To mirror your iPhone, open Control Center, tap Screen Mirroring, and choose a compatible AirPlay receiver. Standard CarPlay is not an AirPlay mirroring receiver.")
                    .multilineTextAlignment(.center).foregroundStyle(.gray)
                Text("Video on a vehicle display should only be used while parked.")
                    .foregroundStyle(Neon.green).font(.footnote)
                Spacer()
            }.padding(24).padding(.top, 50)
        }.navigationTitle("Share Screen")
    }
}

struct DemonChannel: Identifiable, Hashable {
    let id: String
    let name: String
    let category: String
    let stream: URL
}
@MainActor
final class DemonIPTVStore: ObservableObject {
    @Published var channels: [DemonChannel] = []
    @Published var error: String?
    @Published var busy = false

    func importM3U(_ source: String) async {
        guard let url = URL(string: source), url.scheme == "https" else {
            error = "Use an HTTPS M3U URL"; return
        }
        busy = true; defer { busy = false }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard data.count < 15_000_000,
                  let text = String(data: data, encoding: .utf8) else {
                throw URLError(.cannotDecodeContentData)
            }
            var title = ""
            var group = "Live TV"
            var found: [DemonChannel] = []
            for row in text.components(separatedBy: .newlines) {
                let line = row.trimmingCharacters(in: .whitespacesAndNewlines)
                if line.hasPrefix("#EXTINF") {
                    title = line.components(separatedBy: ",").dropFirst().joined(separator: ",")
                    if let part = line.range(of: "group-title=\"") {
                        let rest = line[part.upperBound...]
                        group = String(rest.prefix(while: { $0 != "\"" }))
                    }
                } else if !line.isEmpty && !line.hasPrefix("#"),
                          let link = URL(string: line),
                          ["https", "http"].contains(link.scheme ?? "") {
                    found.append(DemonChannel(id: UUID().uuidString,
                                              name: title.isEmpty ? "Channel" : title,
                                              category: group, stream: link))
                    title = ""; group = "Live TV"
                }
            }
            channels = found
            error = found.isEmpty ? "No channels found in playlist" : nil
        } catch {
            self.error = error.localizedDescription
        }
    }

    func importXtream(server: String, username: String, password: String) async {
        guard var parts = URLComponents(string: server),
              parts.scheme == "https", parts.host != nil else {
            error = "Use a valid HTTPS server URL"; return
        }
        parts.path = "/player_api.php"
        parts.queryItems = [
            URLQueryItem(name: "username", value: username),
            URLQueryItem(name: "password", value: password),
            URLQueryItem(name: "action", value: "get_live_streams")
        ]
        guard let api = parts.url else { error = "Invalid server"; return }
        busy = true; defer { busy = false }
        do {
            let (data, _) = try await URLSession.shared.data(from: api)
            guard data.count < 20_000_000 else { throw URLError(.dataLengthExceedsMaximum) }
            let values = try JSONDecoder().decode([XtreamLive].self, from: data)
            let base = URL(string: server)!
            channels = values.compactMap { item in
                let id = String(item.stream_id)
                let path = "live/\(username)/\(password)/\(id).m3u8"
                guard let stream = URL(string: path, relativeTo: base)?.absoluteURL else { return nil }
                return DemonChannel(id: id, name: item.name,
                                    category: item.category_id ?? "Live TV", stream: stream)
            }
            error = channels.isEmpty ? "No live channels returned" : nil
        } catch {
            self.error = error.localizedDescription
        }
    }
}
private struct XtreamLive: Decodable {
    let name: String
    let stream_id: Int
    let category_id: String?
}
struct DemonIPTVView: View {
    @StateObject private var store = DemonIPTVStore()
    @State private var method = 0
    @State private var playlist = ""
    @State private var server = ""
    @State private var username = ""
    @State private var password = ""
    @State private var search = ""
    @State private var selected: DemonChannel?
    @State private var favoriteIDs: Set<String> = []

    private var filtered: [DemonChannel] {
        store.channels.filter {
            search.isEmpty || $0.name.localizedCaseInsensitiveContains(search)
        }
    }
    var body: some View {
        ZStack {
            Neon.bg.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 15) {
                    Picker("Provider", selection: $method) {
                        Text("M3U").tag(0)
                        Text("Xtream").tag(1)
                    }.pickerStyle(.segmented)
                    if method == 0 {
                        TextField("HTTPS playlist URL", text: $playlist)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
                            .autocorrectionDisabled()
                    } else {
                        TextField("HTTPS Server URL", text: $server)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.URL)
                            .autocorrectionDisabled()
                        TextField("Username", text: $username)
                            .textInputAutocapitalization(.never)
                        SecureField("Password", text: $password)
                    }
                    Button {
                        Task {
                            if method == 0 { await store.importM3U(playlist) }
                            else { await store.importXtream(server: server, username: username, password: password) }
                        }
                    } label: {
                        HStack {
                            if store.busy { ProgressView() }
                            Text("Load Channels").fontWeight(.bold)
                        }.frame(maxWidth: .infinity).padding(13)
                    }
                    .disabled(store.busy)
                    .buttonStyle(.plain).background(Neon.green, in: RoundedRectangle(cornerRadius: 13))
                    .foregroundStyle(.black)
                    if let error = store.error {
                        Text(error).font(.footnote).foregroundStyle(.orange)
                    }
                    TextField("Search channels", text: $search)
                        .textInputAutocapitalization(.never)
                    ForEach(filtered) { channel in
                        HStack {
                            Button {
                                selected = channel
                            } label: {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(channel.name).fontWeight(.semibold)
                                    Text(channel.category).font(.caption).foregroundStyle(.gray)
                                }
                                Spacer()
                            }.buttonStyle(.plain)
                            Button {
                                if favoriteIDs.contains(channel.id) { favoriteIDs.remove(channel.id) }
                                else { favoriteIDs.insert(channel.id) }
                            } label: {
                                Image(systemName: favoriteIDs.contains(channel.id) ? "star.fill" : "star")
                                    .foregroundStyle(Neon.green)
                            }
                        }
                        .padding(12).background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
                    }
                }.padding(20)
            }.textFieldStyle(.roundedBorder)
        }
        .navigationTitle("IPTV")
        .sheet(item: $selected) { channel in
            DemonVideoView(url: channel.stream)
        }
    }
}
struct DemonVideoView: View {
    let url: URL
    var body: some View {
        VideoPlayer(player: AVPlayer(url: url))
            .background(.black)
            .ignoresSafeArea()
    }
}
