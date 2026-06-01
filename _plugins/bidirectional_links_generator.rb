# frozen_string_literal: true
class BidirectionalLinksGenerator < Jekyll::Generator
  def generate(site)
    graph_nodes = []
    graph_edges = []

    all_notes = site.collections['notes'].docs
    all_pages = site.pages

    all_docs = all_notes + all_pages

    link_extension = !!site.config["use_html_extension"] ? '.html' : ''
    link_targets = {}
    all_docs.each do |note_potentially_linked_to|
      new_href = "#{site.baseurl}#{note_potentially_linked_to.url}#{link_extension}"
      link_keys_for_note(note_potentially_linked_to).each do |key|
        link_targets[key] ||= new_href
      end
    end

    # Convert all Wiki/Roam-style double-bracket link syntax to plain HTML
    # anchor tag elements (<a>) with "internal-link" CSS class
    all_docs.each do |current_note|
      next unless current_note.content.include?('[[')

      current_note.content = current_note.content.gsub(/\[\[([^\]\|]+)(?:\|(.+?)(?=\]))?\]\]/i) do
        link_text = Regexp.last_match(1)
        label = Regexp.last_match(2) || link_text
        invalid_label = Regexp.last_match(2) ? "#{link_text}|#{label}" : label
        href = link_targets[normalized_link_key(link_text)] || link_targets[loose_link_key(link_text)]

        if href
          "<a class='internal-link' href='#{href}'>#{label}</a>"
        else
          invalid_link(invalid_label)
        end
      end
    end

    # Identify note backlinks and add them to each note
    all_notes.each do |current_note|
      # Nodes: Jekyll
      notes_linking_to_current_note = all_notes.filter do |e|
        e.content.include?(current_note.url)
      end

      # Nodes: Graph
      graph_nodes << {
        id: note_id_from_note(current_note),
        path: "#{site.baseurl}#{current_note.url}#{link_extension}",
        label: current_note.data['title'],
      } unless current_note.path.include?('_notes/index.html')

      # Edges: Jekyll
      current_note.data['backlinks'] = notes_linking_to_current_note

      # Edges: Graph
      notes_linking_to_current_note.each do |n|
        graph_edges << {
          source: note_id_from_note(n),
          target: note_id_from_note(current_note),
        }
      end
    end

    File.write('_includes/notes_graph.json', JSON.dump({
      edges: graph_edges,
      nodes: graph_nodes,
    }))
  end

  def note_id_from_note(note)
    note.data['title'].bytes.join
  end

  def link_keys_for_note(note)
    basename = File.basename(note.basename, File.extname(note.basename))
    keys = [normalized_link_key(basename), loose_link_key(basename)]

    title = note.data['title']
    keys << normalized_link_key(title) if title

    keys.uniq
  end

  def normalized_link_key(value)
    value.to_s.strip.downcase.gsub(/\s+/, ' ')
  end

  def loose_link_key(value)
    value.to_s.strip.downcase.tr('_-', ' ').gsub(/\s+/, ' ')
  end

  def invalid_link(label)
    <<~HTML.delete("\n")
      <span title='There is no note that matches this link.' class='invalid-link'>
        <span class='invalid-link-brackets'>[[</span>
        #{label}
        <span class='invalid-link-brackets'>]]</span></span>
    HTML
  end
end
