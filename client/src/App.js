import React, { useEffect, useState } from 'react';
import ReactDOM from 'react-dom/client';

const App = () => {
  const [posts, setPosts] = useState([]);
  const [selectedPostId, setSelectedPostId] = useState('');
  const [form, setForm] = useState({ author: '', title: '', content: '' });
  const [updateForm, setUpdateForm] = useState({ id: '', author: '', content: '' });
  const [deleteId, setDeleteId] = useState('');
  const [range, setRange] = useState({ from: '', to: '' });

  const fetchPosts = async () => {
    try {
      const res = await fetch('/posts');
      if (!res.ok) throw new Error('Failed to fetch posts');
      const data = await res.json();
      setPosts(Array.isArray(data) ? data : []);
    } catch (err) {
      alert(err.message);
    }
  };

  const fetchRange = async () => {
    try {
      const res = await fetch(`/posts/range?from=${range.from}&to=${range.to}`);
      if (!res.ok) throw new Error('Failed to fetch range');
      const data = await res.json();
      setPosts(Array.isArray(data) ? data : []);
    } catch (err) {
      alert(err.message);
    }
  };
  
  const createPost = async () => {
    if (!form.author || !form.title || !form.content) {
      alert("Please fill in all fields.");
      return;
    }
    try {
      const res = await fetch('/posts', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(form),
      });
      if (!res.ok) {
        const errData = await res.json();
        throw new Error(errData.error || 'Failed to create post');
      }
      fetchPosts();
    } catch (err) {
      alert(err.message);
    }
  };
  
  const handlePostSelect = async (id) => {
    try {
      setSelectedPostId(id);
      const res = await fetch(`/posts/${id}`);
      if (!res.ok) throw new Error('Failed to fetch post data');
      const data = await res.json();
      setUpdateForm({
        id: id,
        author: '',
        content: data.content,
      });
    } catch (err) {
      alert(err.message);
    }
  };
  
  const updatePost = async () => {
    if (!updateForm.author || !updateForm.content) {
      alert("Please fill in both author and content.");
      return;
    }
    try {
      const res = await fetch(`/posts/${updateForm.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ author: updateForm.author, content: updateForm.content }),
      });
      if (!res.ok) {
        const errData = await res.json();
        throw new Error(errData.error || 'Failed to update post');
      }
      fetchPosts();
    } catch (err) {
      alert(err.message);
    }
  };
  
  const deletePost = async () => {
    if (!deleteId) {
      alert("Please select a post to delete.");
      return;
    }
    try {
      const res = await fetch(`/posts/${deleteId}`, { method: 'DELETE' });
      if (!res.ok) {
        const errData = await res.json();
        throw new Error(errData.error || 'Failed to delete post');
      }
      fetchPosts();
    } catch (err) {
      alert(err.message);
    }
  };

  useEffect(() => {
    fetchPosts();
  }, []);

  return (
    <div style={{ display: 'flex', fontFamily: 'Arial' }}>
      <div style={{ width: '60%', padding: '20px', borderRight: '1px solid #ccc', height: '100vh', overflowY: 'auto' }}>
        <h2>All Posts</h2>
        {posts.map(p => (
          <div key={p.id} style={{ borderBottom: '1px solid #ccc', marginBottom: '10px' }}>
            <strong>{p.title || '(No Title)'}</strong><br />
            by {p.author}<br />
            {p.content}<br />
            <small> id: {p.id}, {p.datetime}</small>
          </div>
        ))}
      </div>

      <div style={{ width: '40%', padding: '20px' }}>
        <h3>Create Post</h3>
        <input style={{ marginBottom: '5px' }} placeholder="Author" value={form.author} onChange={e => setForm({ ...form, author: e.target.value })} /><br />
        <input style={{ marginBottom: '5px' }} placeholder="Title" value={form.title} onChange={e => setForm({ ...form, title: e.target.value })} /><br />
        <textarea style={{ marginBottom: '5px' }} placeholder="Content" value={form.content} onChange={e => setForm({ ...form, content: e.target.value })} /><br />
        <button onClick={createPost}>Submit</button>

        <h3>Update Post</h3>
        <select  style={{ marginBottom: '5px' }} value={selectedPostId} onChange={e => handlePostSelect(e.target.value)}>
          <option value="">Select a post ID</option>
          {posts.map(post => (
            <option key={post.id} value={post.id}>
              ID {post.id}: {post.title || '(No Title)'}
            </option>
          ))}
        </select><br />

        <input
          style={{ marginBottom: '5px' }}
          placeholder="New Author (append)"
          value={updateForm.author}
          onChange={e => setUpdateForm({ ...updateForm, author: e.target.value })}
        /><br />

        <textarea
          style={{ marginBottom: '5px' }}
          placeholder="New Content"
          value={updateForm.content}
          onChange={e => setUpdateForm({ ...updateForm, content: e.target.value })}
        /><br />

        <button onClick={updatePost} disabled={!updateForm.id}>Update</button>

        <h3>Delete Post</h3>
        <select style={{ marginBottom: '5px' }} value={deleteId} onChange={e => setDeleteId(e.target.value)}>
          <option value="">Select a post to delete</option>
          {posts.map(post => (
            <option key={post.id} value={post.id}>
              ID {post.id}: {post.title || '(No Title)'}
            </option>
          ))}
        </select><br />
        <button onClick={deletePost} disabled={!deleteId}>Delete</button>

        <h3>Search by Date Range</h3>
        <input  style={{ marginBottom: '5px', marginRight: '5px' }} type="date" value={range.from} onChange={e => setRange({ ...range, from: e.target.value })} />
        <input type="date" value={range.to} onChange={e => setRange({ ...range, to: e.target.value })} /><br />
        <button onClick={fetchRange}>Search</button>
      </div>
    </div>
  );
};

export default App;